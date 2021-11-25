class TotalCosts::WorkResultsController < ApplicationController
  include PermitManager

  def index
    @errors = TotalCost.for_worker(current_term).where(cost_type_id: nil)
  end
end
