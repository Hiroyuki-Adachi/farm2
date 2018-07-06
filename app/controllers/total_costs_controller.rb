class TotalCostsController < ApplicationController
  include PermitManager

  def index
    @work_types = WorkType.land
    @lands = LandCost.total(Time.zone.today)
  end
end
