class DepreciationsController < ApplicationController
  include PermitManager

  def index
    @machines = Machine.includes(:owner).of_company.between_term(current_system).usual
    @work_types = WorkType.land
    @depreciations = Depreciation.includes(:work_types).usual(current_term)
  end

  def create
    Depreciation.transaction do
      params[:depreciations].each do |dep_param|
        if dep_param[:id].present?
          depreciation = Depreciation.find(dep_param[:id])
          depreciation.update(depreciation_params(dep_param))
        else
          depreciation = Depreciation.create(depreciation_params(dep_param))
        end
        depreciation.regist_work_types(dep_param[:work_types]) if dep_param[:work_types]
      end
    end
    redirect_to depreciations_path
  end

  private

  def depreciation_params(params)
    params.permit(:id, :cost, :machine_id, :term)
  end
end
