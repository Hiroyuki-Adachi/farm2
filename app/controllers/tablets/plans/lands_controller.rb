class Tablets::Plans::LandsController < Tablets::PlansController
  helper GmapHelper

  def new
    @lands = Land.for_plan(current_user.id, next_term).expiry(plan_date).includes(:owner)
    @work_types = WorkType.land.by_term(next_term)
  end

  def create
    PlanLand.create_all(current_user, next_term, params.fetch(:land, {}), current_organization)
    redirect_to new_tablets_plans_land_path, notice: "登録しました。"
  end

  def destroy
    PlanLand.clear_all(current_user.id, next_term, plan_date, current_organization)
    redirect_to new_tablets_plans_land_path, notice: "初期化しました。", status: :see_other
  end

  private

  def plan_date
    next_system.start_date
  end
end
