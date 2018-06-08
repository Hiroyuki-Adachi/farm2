class FuelCostsController < ApplicationController
  include PermitManager

  before_action :set_machines, only: [:index]
  before_action :set_system
  before_action :set_works, only: [:index]

  def index
    @machine_results = MachineResult.includes(:work_result).by_works(@works)
    @works = WorkDecorator.decorate_collection(@works)
  end

  def create
  end

  private

  def set_machines
    @machines = Machine.includes(:owner).diesel.usual
  end

  def set_system
    @system = current_system
  end

  def set_works
    @works = Work.by_machines(@machines).by_types(WorkType.land).by_term(current_term)
  end
end
