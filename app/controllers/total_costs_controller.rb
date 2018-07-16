class TotalCostsController < ApplicationController
  include PermitManager

  def index
    @work_types = WorkType.land
    @lands = LandCost.total(Time.zone.today)
    @total_costs = TotalCost.usual(current_term)
  end

  def create
    TotalCost.transaction do
      TotalCost.make(current_term)
    end
    redirect_to total_costs_path
  end
end
