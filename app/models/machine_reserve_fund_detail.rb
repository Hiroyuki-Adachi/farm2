# == Schema Information
#
# Table name: machine_reserve_fund_details(基盤強化準備金原価明細)
#
#  id                                          :bigint           not null, primary key
#  amount(原価額)                              :decimal(9, )     not null
#  months(按分月数)                            :integer          not null
#  remaining_amount(残額)                      :decimal(9, )     not null
#  term(年度(期))                              :integer          not null
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  machine_reserve_fund_id(基盤強化準備金原価) :bigint           not null
#  organization_id(組織)                       :bigint           not null
#
# Indexes
#
#  idx_reserve_fund_details_on_fund_and_term                      (machine_reserve_fund_id,term) UNIQUE
#  index_machine_reserve_fund_details_on_machine_reserve_fund_id  (machine_reserve_fund_id)
#  index_machine_reserve_fund_details_on_organization_id          (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (machine_reserve_fund_id => machine_reserve_funds.id)
#  fk_rails_...  (organization_id => organizations.id)
#
class MachineReserveFundDetail < ApplicationRecord
  belongs_to :organization, optional: false
  belongs_to :machine_reserve_fund, optional: false

  has_many :machine_reserve_fund_costs, dependent: :destroy, autosave: true

  validates :term, presence: true, uniqueness: { scope: :machine_reserve_fund_id }
  validates :months, numericality: { only_integer: true, in: 1..12 }
  validates :amount, :remaining_amount, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validate :associations_same_organization
  validate :cost_total_matches_amount, on: :costs

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }

  # 親をロックして、重複登録・並行登録による残額超過を防ぐ。
  def register(system) # rubocop:disable Naming/PredicateMethod
    unless system.organization_id == organization_id && system.term == term
      errors.add(:base, "年度または組織が一致しません。")
      return false
    end

    machine_reserve_fund.with_lock do
      self.months = machine_reserve_fund.months_for(system)
      self.remaining_amount = machine_reserve_fund.current_remaining_amount - (amount || 0)
      return false unless valid?

      allocate_costs(system)
      return false if errors.any?

      return false unless save

      refresh_balances!
    end
    true
  end

  def destroy_with_balance!
    machine_reserve_fund.with_lock do
      destroy!
      refresh_balances!
    end
  end

  def prepare_costs
    work_types = WorkType.land.by_term(term).to_a
    costs = machine_reserve_fund_costs.to_a
    costs.each { |cost| cost.mark_for_destruction unless work_types.any? { |type| type.id == cost.work_type_id } }
    work_types.map do |work_type|
      costs.find { |cost| cost.work_type_id == work_type.id } || machine_reserve_fund_costs.build(
        organization: organization, work_type: work_type, cost: 0
      )
    end
  end

  def update_costs(values)
    machine_reserve_fund.with_lock do
      with_lock do
        prepare_costs.each { |cost| cost.cost = cost.allocation_enabled? ? values[cost.work_type_id.to_s] : 0 }
        return save(context: :costs)
      end
    end
  end

  def reallocate_costs(system, selected_work_type_ids: nil)
    unless system.organization_id == organization_id && system.term == term
      errors.add(:base, "年度または組織が一致しません。")
      return false
    end

    machine_reserve_fund.with_lock do
      with_lock do
        errors.clear
        allocate_costs(system, selected_work_type_ids: selected_work_type_ids)
        return false if errors.any?

        return save(context: :costs)
      end
    end
  end

  private

  def refresh_balances!
    balance = machine_reserve_fund.remaining_amount
    machine_reserve_fund.machine_reserve_fund_details.order(:term).each do |detail|
      balance -= detail.amount
      detail.update!(remaining_amount: balance)
    end
  end

  def accumulated_areas(system)
    work_types = WorkType.land.by_term(term).to_a
    return {} if work_types.empty?

    totals = Hash.new(0)
    work_type_ids = work_types.map(&:id)
    (system.start_date..system.end_date).each do |day|
      LandCost.sum_areas_by_work_type(day, work_type_ids, organization_id).each do |work_type_id, area|
        totals[work_type_id] += area
      end
    end
    work_types.index_with { |work_type| totals[work_type.id] }
  end

  def allocate_costs(system, selected_work_type_ids: nil)
    costs = prepare_costs
    areas = selected_allocation_areas(system, costs, selected_work_type_ids)
    return if errors.any?

    total_area = areas.values.sum
    if total_area.zero?
      errors.add(:base, "当期の按分対象の圃場面積が0のため登録できません。")
      return
    end

    assign_allocated_costs(costs, areas, total_area)
  end

  def selected_allocation_areas(system, costs, selected_work_type_ids)
    areas = accumulated_areas(system)
    if areas.empty?
      errors.add(:base, "当期の按分対象の圃場面積が0のため登録できません。")
      return {}
    end
    selected_ids = allocation_selection_ids(costs, selected_work_type_ids)
    return {} unless valid_allocation_selection?(selected_ids, areas.keys.map { |type| type.id.to_s })

    areas.select { |type, _area| selected_ids.include?(type.id.to_s) }
  end

  def allocation_selection_ids(costs, selected_work_type_ids)
    (selected_work_type_ids || costs.select(&:allocation_enabled?).map(&:work_type_id)).map(&:to_s)
  end

  def assign_allocated_costs(costs, areas, total_area)
    costs.each do |cost|
      cost.allocation_enabled = areas.key?(cost.work_type)
      cost.cost = cost.allocation_enabled? ? (amount * areas.fetch(cost.work_type) / total_area).round : 0
    end
    costs.select(&:allocation_enabled?).max_by(&:cost).cost += amount - costs.sum(&:cost)
  end

  def valid_allocation_selection?(selected_ids, eligible_ids)
    if selected_ids.empty?
      errors.add(:base, "原価に入れる作業分類を1つ以上選択してください。")
    elsif (selected_ids - eligible_ids).any?
      errors.add(:base, "当期の按分対象ではない作業分類が含まれています。")
    end
    errors.empty?
  end

  def cost_total_matches_amount
    costs = machine_reserve_fund_costs.reject(&:marked_for_destruction?)
    return if costs.any? { |cost| cost.cost.nil? }
    return if costs.sum(&:cost) == amount

    errors.add(:base, "作業分類別原価の合計は原価額と一致させてください。")
  end

  def associations_same_organization
    return if organization_id.blank?

    if machine_reserve_fund.present? && machine_reserve_fund.organization_id != organization_id
      errors.add(:machine_reserve_fund_id, :invalid)
    end
  end
end
