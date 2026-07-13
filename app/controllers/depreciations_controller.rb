class DepreciationsController < ApplicationController
  include PermitManager

  def index
    @machines = Machine.for_organization(current_organization)
      .includes(:owner).of_company.between_term(current_system).usual
    @work_types = WorkType.land
    @depreciations = Depreciation.for_organization(current_organization).includes(:work_types).usual(current_term)
  end

  def create
    Depreciation.transaction do
      params[:depreciations].each do |dep_param|
        machine = scoped_machine(dep_param)
        if dep_param[:id].present?
          depreciation = Depreciation.for_organization(current_organization).find(dep_param[:id])
          depreciation.update(depreciation_params(dep_param).merge(machine: machine))
        else
          depreciation = Depreciation.create(depreciation_params(dep_param).merge(machine: machine))
        end
        depreciation.regist_work_types(dep_param[:work_types]) if dep_param[:work_types]
      end
    end
    redirect_to depreciations_path
  end

  private

  def depreciation_params(params)
    params.permit(:cost, :term)
  end

  def scoped_machine(params)
    Machine.for_organization(current_organization).find(params[:machine_id])
  end
end
