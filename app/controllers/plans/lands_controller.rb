require 'securerandom'
class Plans::LandsController < PlansController
  before_action :validate_mode
  helper GmapHelper
  TERM_MODES = { current: '0', next: '1' }.freeze

  def index
    work_types = WorkType.land.by_term(plan_term)
    plan_lands = PlanLand.usual(current_user, plan_term)
    z_gis_file = ZgisExcelService.call(plan_lands, work_types, plan_term)
    send_data File.read(z_gis_file), filename: "zgis.zip", type: 'application/zip'
    File.delete(z_gis_file)
  end

  def new
    @lands = Land.for_plan(current_user.id, plan_term).expiry(current_date).includes(:owner)
    @work_types = WorkType.land.by_term(plan_term)
  end

  def create
    PlanLand.create_all(current_user.id, plan_term, params["land"])
    redirect_to new_plans_land_path(mode: params[:mode])
  end

  def destroy
    PlanLand.clear_all(current_user.id, plan_term, current_date)
    redirect_to new_plans_land_path(mode: params[:mode]), status: :see_other
  end

  private

  def menu_name
    return :plan_lands
  end

  def current_date
    if params[:mode] == TERM_MODES[:current]
      Time.zone.now.to_date
    else
      System.find_by(term: plan_term, organization_id: current_organization.id)&.start_date
    end
  end

  def validate_mode
    to_error_path unless TERM_MODES.value?(params[:mode])
  end

  def plan_term
    @plan_term ||= (params[:mode] == TERM_MODES[:next] ? next_term : current_term)
  end
end
