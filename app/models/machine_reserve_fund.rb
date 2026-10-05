# == Schema Information
#
# Table name: machine_reserve_funds(基盤強化準備金原価)
#
#  id                             :bigint           not null, primary key
#  remaining_amount(残額(初期値)) :decimal(9, )     not null
#  started_on(開始年月)           :date             not null
#  total_amount(総額)             :decimal(9, )     not null
#  years(配分年数)                :integer          default(7), not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  machine_id(機械)               :integer          not null
#  organization_id(組織)          :bigint           not null
#
# Indexes
#
#  index_machine_reserve_funds_on_machine_id       (machine_id) UNIQUE
#  index_machine_reserve_funds_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class MachineReserveFund < ApplicationRecord
  belongs_to :organization, optional: false
  belongs_to :machine, optional: false

  has_many :machine_reserve_fund_details, dependent: :restrict_with_exception

  validates :started_on, presence: true
  validates :years, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :remaining_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :machine_id, uniqueness: true
  validate :machine_belongs_to_organization
  validate :remaining_amount_within_total_amount
  validate :remaining_amount_not_less_than_registered_amount
  validate :total_amount_unchanged_with_details, on: :update

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }
  scope :usual, lambda {
    joins(machine: :machine_type)
      .order(:started_on, "machine_types.display_order", "machines.display_order", "machines.id")
  }

  def registered_amount
    if machine_reserve_fund_details.loaded?
      machine_reserve_fund_details.sum(&:amount)
    else
      machine_reserve_fund_details.sum(:amount)
    end
  end

  # 登録済み明細(このシステムで按分・記録した分)を反映した現在の残額。
  # remaining_amount(カラム)は登録時点の残額であり、明細が積み上がるほど減っていく。
  def current_remaining_amount
    remaining_amount - registered_amount
  end

  def details?
    machine_reserve_fund_details.exists?
  end

  # 開始日の月を含む、配分期間と会計年度の共通月数。
  def months_for(system)
    first = [started_on.beginning_of_month, system.start_date].max
    last = [started_on.beginning_of_month >> (years * 12), system.end_date.next_day].min
    [((last.year - first.year) * 12) + last.month - first.month, 0].max
  end

  def amount_for(system)
    return 0 if months_for(system).zero?

    [(total_amount.to_d * months_for(system) / (years * 12)).round, current_remaining_amount].min
  end

  def build_detail(system)
    machine_reserve_fund_details.build(
      organization: organization, term: system.term, months: months_for(system),
      amount: amount_for(system), remaining_amount: current_remaining_amount - amount_for(system)
    )
  end

  private

  def total_amount_unchanged_with_details
    return unless will_save_change_to_total_amount? && details?

    errors.add(:total_amount, "は明細が存在するため変更できません。")
  end

  # machine_idはクライアントから送られてくるため、他組織/個人所有の機械が紐付けられないようサーバ側でも検証する
  def machine_belongs_to_organization
    return if organization.nil? || machine_id.nil?

    valid_machine = Machine.for_organization(organization).of_company.exists?(id: machine_id)
    errors.add(:machine_id, "は選択できません。") unless valid_machine
  end

  # 登録時点の残額は総額を超えられない
  def remaining_amount_within_total_amount
    return if total_amount.nil? || remaining_amount.nil?

    errors.add(:remaining_amount, "は総額より大きくできません。") if remaining_amount > total_amount
  end

  # 登録済み明細の合計額より小さい残額には変更できない(登録済み分を後退させないため)
  def remaining_amount_not_less_than_registered_amount
    return if remaining_amount.nil?

    errors.add(:remaining_amount, "は登録済みの原価額より小さくできません。") if remaining_amount < registered_amount
  end
end
