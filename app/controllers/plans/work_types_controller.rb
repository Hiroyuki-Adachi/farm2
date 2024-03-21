class Plans::WorkTypesController < ApplicationController
  include PermitManager
  before_action :permit_this_term
  before_action :save_system, only: [:new]

  def new
    @work_types = WorkType.land
  end

  def create
    WorkType.transaction do
      params[:work_types].each do |key, value|
        work_type = WorkType.find(key)
        work_type.term = next_term
        work_type.term_flag = value[:term_flag]
        work_type.bg_color = value[:bg_color]
        work_type.save!
      end
    end
    redirect_to new_plans_work_type_path
  end

  private

  def menu_name
    return :plan_work_types
  end

  def save_system
    System.init(current_organization.id, current_term + 1).save!
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
