class Plans::LandsController < ApplicationController
  include PermitManager

  helper GmapHelper

  def new
    @lands = Land.for_plan(current_user.id).includes(:owner)
    @work_types = WorkType.land
  end

  def create
    PlanLand.create_all(current_user.id, params["land"])
    redirect_to new_plans_land_path
  end

  def destroy
    PlanLand.clear_all(current_user.id, Date.today)
    redirect_to new_plans_land_path
  end

  private

  def menu_name
    return :plan_lands
  end
end
