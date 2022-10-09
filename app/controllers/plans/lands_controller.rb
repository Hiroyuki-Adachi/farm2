class Plans::LandsController < ApplicationController
  include PermitManager
  before_action :set_current_date, only: [:new]

  helper GmapHelper

  def new
    @lands = Land.for_plan(current_user.id).expiry(@current_date).includes(:owner)
    @work_types = WorkType.land.by_term(current_term)
  end

  def create
    PlanLand.create_all(current_user.id, params["land"])
    redirect_to new_plans_land_path
  end

  def destroy
    PlanLand.clear_all(current_user.id, Date.today)
    redirect_to new_plans_land_path, status: :see_other
  end

  private

  def menu_name
    return :plan_lands
  end

  def set_current_date
    @current_date = current_term == current_organization.get_system(Date.today).term ? Date.today : current_system.start_date
  end
end
