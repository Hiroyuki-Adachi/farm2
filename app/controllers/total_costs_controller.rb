class TotalCostsController < ApplicationController
  include PermitManager

  def index
    @work_types = WorkType.land
    @lands = LandCost.total(current_term)
  end
end
