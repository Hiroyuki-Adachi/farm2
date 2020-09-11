class Plans::LandsController < ApplicationController
  include PermitManager

  helper GmapHelper

  def new
    @lands = Land.regionable.includes(:plan_land)
    @work_types = WorkType.land
  end

  def create
    PlanLand.create_all(params["land"])
    redirect_to new_plans_land_path
  end

  private

  def menu_name
    return :plan_lands
  end
end
