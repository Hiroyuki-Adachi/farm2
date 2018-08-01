class TotalCostsController < ApplicationController
  include PermitManager

  def index
    @work_types = WorkType.land
    @lands = LandCost.total(Time.zone.today)
    @total_costs = TotalCostDecorator.decorate_collection(TotalCost.usual(current_term))
    @group1_costs, @group2_costs = calc_totals(@total_costs.object)
  end

  def create
    TotalCost.transaction do
      TotalCost.make(current_term, current_organization)
    end
    redirect_to total_costs_path
  end

  private

  def calc_totals(total_costs)
    group1_totals = Hash.new { |h, k| h[k] = {}}
    group2_totals = Hash.new { |h, k| h[k] = {}}
    total_costs.each do |tc|
      group1_totals = set_totals(group1_totals, tc, tc.total_cost_type_id)
      group2_totals = set_totals(group2_totals, tc, tc.total_cost_type_id * 1_000_000 + tc.display_order)
    end

    return group1_totals, group2_totals
  end

  def set_totals(totals, cost, key)
    cost.total_cost_details.each do |tcd|
      totals[key][tcd.work_type_id] ||= 0
      totals[key][tcd.work_type_id] += tcd.cost
    end
    return totals
  end
end
