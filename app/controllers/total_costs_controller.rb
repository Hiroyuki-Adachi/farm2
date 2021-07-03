class TotalCostsController < ApplicationController
  include PermitManager

  def index
    @fixes = Fix.usual(current_term)
    @making_flag = Delayed::Job.exists?
    @work_types = WorkType.land
    @lands = LandCost.total(Time.zone.today)
    @total_directs = TotalCostDecorator.decorate_collection(TotalCost.usual(current_term).direct)
    @total_sales = TotalCostDecorator.decorate_collection(TotalCost.usual(current_term).sales)
    @group1_directs, @group2_directs, @sum_directs = calc_totals(@total_directs.object)
    @group1_sales, @group2_sales, @sum_sales = calc_totals(@total_sales.object)
  end

  def create
    TotalCostsMakeJob.perform_later(current_term, current_organization, params[:fixed_on])
    redirect_to total_costs_path
  end

  private

  def calc_totals(total_costs)
    sum_costs = {}
    group1_totals = Hash.new { |h, k| h[k] = {}}
    group2_totals = Hash.new { |h1, k1| h1[k1] = Hash.new { |h2, k2| h2[k2] = {}}}
    total_costs.each do |tc|
      set_totals(sum_costs, tc, nil)
      set_totals(group1_totals, tc, tc.total_cost_type_id)
      set_totals(group2_totals[tc.total_cost_type_id], tc, tc.display_order)
    end

    return group1_totals, group2_totals, sum_costs
  end

  def set_totals(totals, cost, key)
    local_totals = key ? totals[key] : totals
    cost.total_cost_details.each do |tcd|
      next if tcd.cost.to_i.zero?
      local_totals[tcd.work_type_id] ||= 0
      local_totals[tcd.work_type_id] += tcd.cost
    end
  end
end
