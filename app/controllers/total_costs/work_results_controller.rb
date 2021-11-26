class TotalCosts::WorkResultsController < ApplicationController
  include PermitManager

  def index
    errors = TotalCost.for_worker(current_term).where(cost_type_id: nil)
    if errors.exists?
      @work_kinds = WorkKind.where(id: errors.joins(:work).pluck("works.work_kind_id"))
      render "errors"
    end
  end
end
