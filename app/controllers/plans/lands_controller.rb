class Plans::LandsController < PlansController
  before_action :validate_mode
  helper GmapHelper
  TERM_MODES = { current: '0', next: '1' }.freeze

  def index
    @plan_lands = PlanLand.usual(current_user, plan_term)
    respond_to { |format| format.csv { render :content_type => 'text/csv; charset=cp943' }}
  end

  def new
    @plan_term = plan_term
    @lands = Land.for_plan(current_user.id, @plan_term).expiry(current_date).includes(:owner)
    @work_types = WorkType.land.by_term(@plan_term)
  end

  def create
    PlanLand.create_all(current_user.id, plan_term, params["land"])
    redirect_to new_plans_land_path(mode: params[:mode])
  end

  def destroy
    PlanLand.clear_all(current_user.id, plan_term, Date.today)
    redirect_to new_plans_land_path(mode: params[:mode]), status: :see_other
  end

  private

  def menu_name
    return :plan_lands
  end

  def current_date
    System.find_by(term: plan_term, organization_id: current_organization.id)&.start_date
  end

  def validate_mode
    to_error_path unless TERM_MODES.value?(params[:mode])
  end

  def plan_term
    params[:mode] == TERM_MODES[:next] ? next_term : current_term
  end
end
