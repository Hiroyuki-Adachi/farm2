class TotalCostsController < ApplicationController
  include PermitManager

  before_action :check_cost_types, only: :index

  def index
    @fixes = Fix.usual(current_organization, current_term)
    @work_types = WorkType.cost.by_term(current_term).kept
    @cost_types = CostType.usual
    @total_costs = TotalCost.sum_work_results(current_organization, current_term)
    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "total_costs_#{current_term}.csv", type: 'text/csv; charset=Shift_JIS'
      end
    end
  end

  def create
    TotalCostsMakeJob.perform_later(current_organization.id, current_term, params[:fixed_on])
    redirect_to total_costs_path
  end

  def destroy
    TotalCost.transaction do
      TotalCost.for_organization(current_organization).where(term: current_term).destroy_all
      current_system.update!(total_cost_fixed_on: nil)
    end
    redirect_to total_costs_path
  end

  private

  def check_cost_types
    errors = TotalCost.for_worker(current_organization, current_term).where(cost_type_id: nil)
    return unless errors.exists?

    respond_to do |format|
      format.html do
        @work_kinds = WorkKind.where(id: errors.joins(:work).pluck("works.work_kind_id"))
        render "errors"
      end
      format.csv { redirect_to total_costs_path }
    end
  end
end
