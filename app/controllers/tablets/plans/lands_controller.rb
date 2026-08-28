class Tablets::Plans::LandsController < Tablets::PlansController
  helper GmapHelper

  def new
    @lands = Land.for_plan(current_user.id, next_term)
      .for_organization(current_organization)
      .expiry(plan_date)
      .includes(:owner)
    @work_types = WorkType.land.by_term(next_term).to_a
    @work_type_colors = work_type_colors
  end

  def create
    plan_lands = validated_plan_lands
    return unless plan_lands

    PlanLand.create_all(current_user, next_term, plan_lands, current_organization)
    redirect_to new_tablets_plans_land_path, notice: "登録しました。"
  end

  def clear
    PlanLand.clear_all(current_user.id, next_term, plan_date, current_organization)
    redirect_to new_tablets_plans_land_path, notice: "初期化しました。", status: :see_other
  end

  private

  def plan_date
    next_system.start_date
  end

  def work_type_colors
    term_colors = WorkTypeTerm.where(
      term: next_term,
      work_type_id: @work_types.map(&:id)
    ).pluck(:work_type_id, :bg_color).to_h

    @work_types.to_h do |work_type|
      bg_color = term_colors[work_type.id] || work_type.bg_color || "#ffffff"
      [work_type.id, { bg: bg_color, fg: WorkType.to_fg_color(bg_color) }]
    end
  end

  def validated_plan_lands
    plan_lands = params.fetch(:land, {})
    allowed_work_type_ids = WorkType.land.by_term(next_term)
      .where(id: plan_lands.values)
      .ids
      .map(&:to_s)
    return plan_lands if plan_lands.values.all? do |work_type_id|
      work_type_id.blank? || allowed_work_type_ids.include?(work_type_id.to_s)
    end

    to_error_path
    nil
  end
end
