class FuelCostsController < ApplicationController
  include PermitManager

  before_action :set_machines, only: [:index]
  before_action :set_works, only: [:index]

  def index
    @machine_results = MachineResult.includes(:work_result).by_works(@works)
    @works = WorkDecorator.decorate_collection(@works)
  end

  def create
    ActiveRecord::Base.transaction do
      current_system.update(system_params)
      params[:machine_results].each do |k, v|
        MachineResult.find(k).update(fuel_usage: v[:fuel_usage]) if v[:fuel_usage] != v[:old_usage]
      end
    end
    redirect_to fuel_costs_path
  end

  private

  def set_machines
    @machines = Machine.includes(:owner).diesel.usual
  end

  def set_works
    @works = Work.by_machines(@machines).by_types(WorkType.land).by_term(current_term)
  end

  def system_params
    params.permit(:light_oil_price)
  end
end
