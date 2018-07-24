# == Schema Information
#
# Table name: total_costs # 集計原価
#
#  id                 :bigint(8)        not null, primary key
#  term               :integer          not null              # 年度(期)
#  total_cost_type_id :integer          not null              # 集計原価種別
#  occurred_on        :date             not null              # 発生日
#  work_id            :integer                                # 作業
#  expense_id         :integer                                # 経費
#  depreciation_id    :integer                                # 減価償却
#  work_chemical_id   :integer                                # 薬剤使用
#  amount             :decimal(9, )     not null              # 原価額
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seedling_home_id   :integer                                # 育苗担当
#

class TotalCost < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work, optional: true
  belongs_to :expense, optional: true
  belongs_to :depreciation, optional: true
  belongs_to :work_chemical, optional: true
  belongs_to :seedling_home, optional: true
  belongs_to :total_cost_type

  has_many :total_cost_details, {dependent: :destroy}

  delegate :name, to: :total_cost_type, prefix: true

  scope :usual, ->(term) {
    includes(:total_cost_details, work: :work_kind, work_chemical: :chemical)
      .where(term: term)
      .order("occurred_on, id")
  }

  def kind_name
    if work_chemical_id.present?
      work_chemical.chemical.name
    elsif work.present?
      work.work_kind.name
    elsif expense.present?
      expense.content
    elsif depreciation.present?
      depreciation.machine&.usual_name
    elsif seedling_home.present?
      seedling_home.home_name
    end
  end

  def self.make(term, organization)
    TotalCost.where(term: term).destroy_all
    make_work(term)
    make_seedling(term, organization)
    TotalCost.where(term: term).find_each do |tc|
      tc.total_cost_details.each do |tcd|
        tcd.cost = tc.cost(tcd.work_type_id)
        tcd.base_cost = tc.base_cost(tcd.work_type_id)
        tcd.save!
      end
    end
  end

  def self.created_at(term)
    TotalCost.where(term: term).minimum(:created_at)
  end

  def cost(work_type_id)
    return nil unless total_cost_details.where(work_type_id: work_type_id).exists?
    return amount * rate(work_type_id)
  end

  def base_cost(work_type_id)
    cost = cost(work_type_id)
    cost / LandCost.sum_area_by_work_type(occurred_on, work_type_id) * 10 if cost
  end

  def rate(work_type_id)
    numer = 0
    denom = 0
    total_cost_details.each do |tcd|
      denom += (tcd.rate * tcd.area)
      numer = tcd.rate * tcd.area if tcd.work_type_id == work_type_id
    end

    return numer / denom
  end

  def self.make_work(term)
    Work.for_cost(term).each do |work|
      make_work_worker(term, work)
      make_work_machine(term, work)
      make_work_chemical(term, work)
    end
  end

  def self.make_work_worker(term, work)
    total_cost = TotalCost.new(
      term: term,
      total_cost_type_id: TotalCostType::WORKWORKER.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: work.sum_workers_amount
    )
    total_cost.save
    make_work_details(work, total_cost)
  end

  def self.make_work_machine(term, work)
    machine_amount = work.sum_machines_amount
    return unless machine_amount&.positive?

    total_cost = TotalCost.new(
      term: term,
      total_cost_type_id: TotalCostType::WORKMACHINE.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: machine_amount
    )
    total_cost.save
    make_work_details(work, total_cost)
  end

  def self.make_work_chemical(term, work)
    work.work_chemicals.each do |wc|
      ct = ChemicalTerm.find_by(term: term, chemical_id: wc.chemical_id)
      next unless ct&.price&.positive?

      total_cost = TotalCost.new(
        term: term,
        total_cost_type_id: TotalCostType::WORKCHEMICAL.id,
        occurred_on: work.worked_at,
        work_id: work.id,
        work_chemical_id: wc.id,
        amount: ct.price * wc.quantity
      )
      total_cost.save
      make_work_chemical_details(work, total_cost, ct)
    end
  end

  def self.make_work_details(work, total_cost)
    if (work.work_lands&.count || 0).positive?
      LandCost.sum_area_by_lands(work.worked_at, work.lands.ids).each do |k, v|
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: k,
          area: v
        )
      end
    else
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        area: LandCost.sum_area_by_work_type(work.worked_at, work.work_type_id)
      )
    end
  end

  def self.make_work_chemical_details(work, total_cost, chemical_term)
    if (work.work_lands&.count || 0).positive?
      LandCost.sum_area_by_lands(work.worked_at, work.lands.ids).each do |k, v|
        cwt = ChemicalWorkType.find_by(chemical_term_id: chemical_term.id, work_type_id: k)
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: k,
          rate: cwt.quantity,
          area: v
        )
      end
    else
      cwt = ChemicalWorkType.find_by(chemical_term_id: chemical_term.id, work_type_id: work.work_type_id)
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        rate: cwt.quantity,
        area: LandCost.sum_area_by_work_type(work.worked_at, work.work_type_id)
      )
    end
  end

  def self.make_seedling(term, organization)
    seedling_price = System.find_by(term: term, organization_id: organization.id).seedling_price
    seedling_homes = SeedlingHome.usual(term).where.not(sowed_on: nil)
    seedling_homes.each do |seedling_home|
      total_cost = TotalCost.new(
        term: term,
        total_cost_type_id: TotalCostType::SEEDLING.id,
        occurred_on: seedling_home.sowed_on,
        seedling_home_id: seedling_home.id,
        amount: seedling_price * seedling_home.cost_quantity
      )
      total_cost.save
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: seedling_home.seedling.work_type_id,
        area: LandCost.sum_area_by_work_type(seedling_home.sowed_on, seedling_home.seedling.work_type_id)
      )
    end
  end

  private_class_method :make_work
  private_class_method :make_work_worker
  private_class_method :make_work_machine
  private_class_method :make_work_chemical
  private_class_method :make_work_details
  private_class_method :make_work_chemical_details
  private_class_method :make_seedling
end
