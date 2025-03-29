class TotalCostsController < ApplicationController
  include PermitManager

  def index
    @fixes = Fix.usual(current_term)
    errors = TotalCost.for_worker(current_term).where(cost_type_id: nil)
    if errors.exists?
      @work_kinds = WorkKind.where(id: errors.joins(:work).pluck("works.work_kind_id"))
      render "errors"
    end
    @work_types = WorkType.cost
    @cost_types = CostType.usual
    @total_costs = TotalCost.sum_work_results(current_term)
  end

  def create
    TotalCostsMakeJob.perform_later(current_term, params[:fixed_on])
    redirect_to total_costs_path
  end

  def destroy
    TotalCost.where(term: current_term).destroy_all
    redirect_to total_costs_path
  end
end
