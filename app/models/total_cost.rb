# == Schema Information
#
# Table name: total_costs
#
#  id                               :bigint           not null, primary key
#  amount(原価額)                   :decimal(9, )     not null
#  display_order(並び順)            :integer          default(0), not null
#  fiscal_flag(決算期フラグ)        :boolean          default(FALSE), not null
#  member_flag(組合員支払フラグ)    :boolean          default(FALSE), not null
#  occurred_on(発生日)              :date             not null
#  term(年度(期))                   :integer          not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  depreciation_id(減価償却)        :integer
#  expense_id(経費)                 :integer
#  land_id(土地)                    :integer
#  machine_id(機械)                 :integer
#  seedling_home_id(育苗担当)       :integer
#  total_cost_type_id(集計原価種別) :integer          not null
#  whole_crop_land_id(WCS土地)      :integer
#  work_chemical_id(薬剤使用)       :integer
#  work_id(作業)                    :integer
#
# Indexes
#
#  index_total_costs_on_term_and_occurred_on  (term,occurred_on)
#
class TotalCost < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work, optional: true
  belongs_to :expense, optional: true
  belongs_to :depreciation, optional: true
  belongs_to :work_chemical, optional: true
  belongs_to :seedling_home, optional: true
  belongs_to :wcs_land, {class_name: "WholeCropLand", foreign_key: "whole_crop_land_id", optional: true}
  belongs_to :land, optional: true
  belongs_to :total_cost_type

  has_many :total_cost_details, {dependent: :destroy}

  delegate :name, to: :total_cost_type, prefix: true

  scope :usual, ->(term) {
    includes(:total_cost_details, :expense, land: :manager, work: :work_kind, work_chemical: :chemical, seedling_home: :home)
      .where(term: term)
      .order("total_cost_type_id, display_order, fiscal_flag, occurred_on, id")
  }

  scope :direct, -> {where(total_cost_type_id: 10..101)}
  scope :sales, -> {where(total_cost_type_id: 200..299)}

  def self.make(term, organization, fixed_on)
    TotalCost.where(term: term).destroy_all
    sys = System.find_by(term: term, organization_id: organization.id)
    make_work(term, fixed_on)
    make_seedling(term, sys)
    make_lands(term, sys)
    make_machines(term, fixed_on)
    # make_expenses(term)
    # make_depreciation(term, sys)
    make_details(term)
    # make_sales(term)
  end

  def self.created_at(term)
    TotalCost.where(term: term).minimum(:created_at)
  end

  def cost(work_type_id)
    work_type = WorkType.find(work_type_id)
    return amount if work_type.cost_only?
    return nil unless total_cost_details.where(work_type_id: work_type_id).exists?
    return amount * rate(work_type_id)
  end

  def base_cost(work_type_id)
    cost = cost(work_type_id)
    sum_area = LandCost.sum_area_by_work_type(occurred_on, work_type_id)
    return 0 if sum_area.zero?
    return cost && !sum_area.zero? ? cost / sum_area * 10 : 0
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

  def self.make_work(term, fixed_on)
    Work.by_term(term).where("worked_at <= ?", fixed_on) .each do |work|
      make_work_worker(term, work)

      # make_work_machine(term, work)
      # make_work_chemical(term, work)
      # make_work_fuel(term, work, sys)
    end
  end

  def self.make_details(term)
    TotalCost.where(term: term).find_each do |tc|
      tc.total_cost_details.each do |tcd|
        tcd.cost = tc.cost(tcd.work_type_id)
        tcd.base_cost = tc.base_cost(tcd.work_type_id)
        tcd.save!
      end
    end
  end

  def self.make_work_worker(term, work)
    total_cost = TotalCost.create(
      term: term,
      total_cost_type_id: work.total_cost_type.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: work.sum_workers_amount,
      display_order: work.work_kind_order,
      cost_type_id: work.work_kind.cost_type_id,
      member_flag: true
    )
    if work.work_type&.cost_flag || work.work_lands.exists?
      make_work_details(work, total_cost)
    else
      make_details_for_indirect(total_cost.id, work.worked_at)
    end
  end

  def self.make_machines(term, fixed_on)
    Work.by_term(term).machinable.where("worked_at <= ?", fixed_on) .each do |work|
      work.machine_results.each do |machine_result|
        make_machine(work, machine_result)
      end
    end
  end

  def self.make_machine(work, machine_result)
    total_cost = TotalCost.create(
      term: work.term,
      total_cost_type_id: TotalCostType::MACHINE.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      machine_id: machine_result.machine_id,
      amount: machine_result.hours * 60,
      display_order: work.work_kind_order,
      member_flag: false
    )
    make_work_details(work, total_cost)
  end

  def self.make_work_machine(term, work)
    machine_amount = work.sum_machines_amount
    return unless machine_amount&.positive?

    total_cost = TotalCost.create(
      term: term,
      total_cost_type_id: TotalCostType::WORKMACHINE.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: machine_amount,
      display_order: work.work_kind_order,
      member_flag: true
    )
    make_work_details(work, total_cost)
  end

  def self.make_work_fuel(term, work, sys)
    machine_fuel = work.sum_machines_fuel
    return unless machine_fuel&.positive?

    fuel_price = sys&.light_oil_price || 0
    return unless fuel_price&.positive?

    total_cost = TotalCost.create(
      term: term,
      total_cost_type_id: TotalCostType::WORKFUEL.id,
      occurred_on: work.worked_at,
      work_id: work.id,
      amount: machine_fuel * fuel_price,
      display_order: work.work_kind_order
    )
    make_work_details(work, total_cost)
  end

  def self.make_work_chemical(term, work)
    work.work_chemicals.each do |wc|
      ct = ChemicalTerm.find_by(term: term, chemical_id: wc.chemical_id)
      next unless ct&.price&.positive?

      total_cost = TotalCost.create(
        term: term,
        total_cost_type_id: TotalCostType::WORKCHEMICAL.id,
        occurred_on: work.worked_at,
        work_id: work.id,
        work_chemical_id: wc.id,
        display_order: wc.chemical_display_order,
        amount: ct.price * wc.quantity
      )
      make_work_chemical_details(work, total_cost, ct)
    end
  end

  def self.make_work_details(work, total_cost)
    if work.work_type.cost_only?
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        area: 0
      )
    elsif (work.work_lands&.count || 0).positive?
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
      total_cost = TotalCost.create(
        term: term,
        total_cost_type_id: TotalCostType::SEEDLING.id,
        occurred_on: seedling_home.sowed_on,
        seedling_home_id: seedling_home.id,
        amount: seedling_price * seedling_home.cost_quantity,
        display_order: seedling_home.home_display_order,
        member_flag: true
      )
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
      next if cost.nil?

      make_lands_sub(term, TotalCostType::AREA.id, land, results, land.area * 100, sys.end_date)
      make_lands_sub(term, TotalCostType::LAND.id, land, results, cost.manage_fee, sys.end_date)
      make_lands_sub(term, TotalCostType::PEASANT.id, land, results, cost.peasant_fee, sys.end_date)
    end
  end

  def self.make_lands_sub(term, cost_type_id, land, results, fee, end_date)
    return unless fee.positive?

    total_cost = TotalCost.create(
      term: term,
      total_cost_type_id: cost_type_id,
      occurred_on: end_date,
      land_id: land.id,
      amount: fee,
      member_flag: true,
      display_order: land.manager.home_display_order,
      fiscal_flag: true
    )
    results.each do |k, v|
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: k,
        rate: v,
        area: land.area
      )
    end
  end

  def self.make_expenses(term)
    Expense.cost(term).each do |expense|
      total_cost = TotalCost.create(
        term: term,
        total_cost_type_id: expense.cost_type,
        occurred_on: expense.payed_on,
        expense_id: expense.id,
        amount: expense.discount_amount,
        display_order: expense.expense_type_id
      )
      if expense.direct?
        expense.expense_work_types.each do |expense_work_type|
          next if expense_work_type.rate.zero?
          TotalCostDetail.create(
            total_cost_id: total_cost.id,
            work_type_id: expense_work_type.work_type_id,
            rate: expense_work_type.rate,
            area: LandCost.sum_area_by_work_type(expense.payed_on, expense_work_type.work_type_id)
          )
        end
      else
        make_details_for_indirect(total_cost.id, expense.payed_on)
      end
    end
  end

  def self.make_depreciation(term, sys)
    days = (sys.end_date - sys.start_date + 1).to_i
    lands = TotalCostDetail.lands(term, days)
    Depreciation.usual(term).where.not(cost: 0).each do |depreciation|
      total_cost = TotalCost.create(
        term: term,
        total_cost_type_id: TotalCostType::DEPRECIATION.id,
        occurred_on: sys.end_date,
        depreciation_id: depreciation.id,
        amount: depreciation.cost,
        display_order: depreciation.machine.machine_type.machine_type_order,
        fiscal_flag: true
      )
      depreciation.depreciation_types.each do |depreciation_type|
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: depreciation_type.work_type_id,
          rate: 1,
          area: lands[depreciation_type.work_type_id]
        )
      end
    end
  end

  def self.make_sales(term)
    make_sales_wcs(term)
    make_sales_broccoli(term)
  end

  def self.make_sales_wcs(term)
    WholeCropLand.for_sales(term).each do |wcs_land|
      next if wcs_land.price.zero?
      land = wcs_land.work_land.land
      work = wcs_land.work_whole_crop.work
      total_cost = TotalCost.create(
        term: term,
        total_cost_type_id: TotalCostType::SALES.id,
        occurred_on: work.worked_at,
        land_id: land.id,
        whole_crop_land_id: wcs_land.id,
        amount: wcs_land.price,
        display_order: land.manager.home_display_order
      )
      TotalCostDetail.create(
        total_cost_id: total_cost.id,
        work_type_id: work.work_type_id,
        cost: wcs_land.price,
        base_cost: wcs_land.price / land.area,
        rate: 1,
        area: land.area
      )
    end
  end

  def self.make_sales_broccoli(term)
    WorkBroccoli.for_sales(term).each do |broccoli|
      sum_area = LandCost.sum_area_by_work_type(broccoli.shipped_on, broccoli.work.work_type_id)
      LandCost.by_work_type(broccoli.work.work_type_id, broccoli.shipped_on).each do |land_cost|
        amount = broccoli.sale * land_cost.land.area / sum_area
        total_cost = TotalCost.create(
          term: term,
          total_cost_type_id: TotalCostType::SALES.id,
          land_id: land_cost.land.id,
          occurred_on: broccoli.shipped_on,
          amount: amount,
          display_order: land_cost.land.manager.home_display_order
        )
        TotalCostDetail.create(
          total_cost_id: total_cost.id,
          work_type_id: broccoli.work.work_type_id,
          cost: amount,
          rate: 1,
          area: land_cost.land.area
        )
      end
      make_cost_broccoli(term, broccoli, sum_area) if broccoli.cost&.positive?
    end
  end

  def self.make_cost_broccoli(term, broccoli, sum_area)
    total_cost = TotalCost.create(
      term: term,
      work_id: broccoli.work.id,
      total_cost_type_id: TotalCostType::SALECOST.id,
      occurred_on: broccoli.shipped_on,
      amount: broccoli.cost,
      display_order: 0
    )
    TotalCostDetail.create(
      total_cost_id: total_cost.id,
      work_type_id: broccoli.work.work_type_id,
      cost: broccoli.cost,
      rate: 1,
      area: sum_area
    )
  end

  def self.make_details_for_indirect(total_cost_id, occurred_on)
    WorkType.land.each do |work_type|
      area = LandCost.sum_area_by_work_type(occurred_on, work_type.id)
      next unless area.positive?
      TotalCostDetail.create(
        total_cost_id: total_cost_id,
        work_type_id: work_type.id,
        rate: 1,
        area: area
      )
    end
  end
end
