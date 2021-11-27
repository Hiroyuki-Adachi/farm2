class TotalCosts::WorkResultsController < ApplicationController
  include PermitManager

  def index
    errors = TotalCost.for_worker(current_term).where(cost_type_id: nil)
    if errors.exists?
      @work_kinds = WorkKind.where(id: errors.joins(:work).pluck("works.work_kind_id"))
      render "errors"
    end
    @work_types = WorkType.cost
    @cost_types = CostType.usual
    @total_costs = TotalCost.sum_work_results(current_term)
  end

  private

  def menu_name
    return :total_costs
  end
end
