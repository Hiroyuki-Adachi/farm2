class Plans::WorkTypesController < ApplicationController
  include PermitManager

  def new
    @work_types = WorkType.land.includes(:plan)
    @plan_lands = PlanLand.group(:work_type_id).joins(:land).sum("lands.area")
  end

  def create
    PlanWorkType.create_all(param_work_types)
    redirect_to new_plans_seedling_path
  end

  private

  def menu_name
    return :plan_seedlings
  end

  def param_work_types
    params.permit(work_types: [
      :area, 
      :month, 
      :quantity, 
      :seeds, 
      :unit,
      :between_stocks,
      :soils,
      :bag_weight1,
      :bag_weight2
      ]).require(:work_types)
  end
end
