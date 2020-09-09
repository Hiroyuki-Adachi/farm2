class Plans::LandsController < ApplicationController
  include PermitManager

  helper GmapHelper

  def new
    @lands = Land.where.not(region: nil).includes(:plan_land)
    @work_types = WorkType.land
  end

  def create
    PlanLand.create_all(params["land"])
    redirect_to new_plans_land_path
  end
end
