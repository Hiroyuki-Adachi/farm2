# == Schema Information
#
# Table name: total_costs # 集計原価
#
#  id                 :bigint(8)        not null, primary key
#  term               :integer          not null                 # 年度(期)
#  total_cost_type_id :integer          not null                 # 集計原価種別
#  occurred_on        :date             not null                 # 発生日
#  work_id            :integer                                   # 作業
#  expense_id         :integer                                   # 経費
#  depreciation_id    :integer                                   # 減価償却
#  work_chemical_id   :integer                                   # 薬剤使用
#  amount             :decimal(9, )     not null                 # 原価額
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seedling_home_id   :integer                                   # 育苗担当
#  member_flag        :boolean          default(FALSE), not null # 組合員支払フラグ
#  land_id            :integer                                   # 土地
#  fiscal_flag        :boolean          default(FALSE), not null # 決算期フラグ
#  display_order      :integer          default(0), not null     # 並び順
#

class TotalCost < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work, optional: true
  belongs_to :expense, optional: true
  belongs_to :depreciation, optional: true
  belongs_to :work_chemical, optional: true
  belongs_to :seedling_home, optional: true
  belongs_to :land, optional: true
  belongs_to :total_cost_type

  has_many :total_cost_details, {dependent: :destroy}

  delegate :name, to: :total_cost_type, prefix: true

  scope :usual, ->(term) {
    includes(:total_cost_details, land: :manager, work: :work_kind, work_chemical: :chemical, seedling_home: :home)
      .where(term: term)
      .order("total_cost_type_id, display_order, fiscal_flag, occurred_on, id")
  }

  def self.make(term, organization)
    TotalCost.where(term: term).destroy_all
    sys = System.find_by(term: term, organization_id: organization.id)
    make_work(term, sys)
    make_seedling(term, sys)
    make_lands(term, sys)
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

  def self.make_work(term, sys)
    Work.for_cost(term).each do |work|
      make_work_worker(term, work)
      make_work_machine(term, work)
      make_work_chemical(term, work)
      make_work_fuel(term, work, sys)
    end
  end

  def self.make_work_worker(term, work)
    total_cost = TotalCost.new(
      term: term,
      total_cost_type_id: TotalCostType::WORKWORKER.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: work.sum_workers_amount,
      display_order: work.work_kind_order,
      member_flag: true
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
      amount: machine_amount,
      display_order: work.work_kind_order,
      member_flag: true
    )
    total_cost.save
    make_work_details(work, total_cost)
  end

  def self.make_work_fuel(term, work, sys)
    machine_fuel = work.sum_machines_fuel
    return unless machine_fuel&.positive?

    fuel_price = sys&.light_oil_price || 0
    return unless fuel_price&.positive?

    total_cost = TotalCost.new(
      term: term,
      total_cost_type_id: TotalCostType::WORKFUEL.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: machine_fuel * fuel_price,
      display_order: work.work_kind_order
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
        display_order: wc.chemical_display_order,
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

  def self.make_seedling(term, sys)
    seedling_price = sys.seedling_price
    seedling_homes = SeedlingHome.usual(term).where.not(sowed_on: nil)
    seedling_homes.each do |seedling_home|
      total_cost = TotalCost.new(
        term: term,
        total_cost_type_id: TotalCostType::SEEDLING.id,
        occurred_on: seedling_home.sowed_on,
        seedling_home_id: seedling_home.id,
        amount: seedling_price * seedling_home.cost_quantity,
        display_order: seedling_home.home_display_order,
        member_flag: true
      )
      total_cost.save
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: seedling_home.seedling.work_type_id,
        area: LandCost.sum_area_by_work_type(seedling_home.sowed_on, seedling_home.seedling.work_type_id)
      )
    end
  end

  def self.make_lands(term, sys)
    Land.usual.each do |land|
      cost, results = land.costs(sys.start_date, sys.end_date)
      next if cost.zero?
      total_cost = TotalCost.new(
        term: term,
        total_cost_type_id: TotalCostType::LAND.id,
        occurred_on: sys.end_date,
        land_id: land.id,
        amount: cost,
        member_flag: true,
        display_order: land.manager.home_display_order,
        fiscal_flag: true
      )
      total_cost.save
      results.each do |k, v|
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: k,
          rate: v,
          area: land.area
        )
      end
    end
  end
end
