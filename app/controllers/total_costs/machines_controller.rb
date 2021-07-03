class TotalCosts::MachinesController < ApplicationController
  include PermitManager

  def index
    @machine_minutes = TotalCostDetail.total_machines(current_term)
    @work_types = WorkType.land
    @machines = Machine.usual.where(id: @machine_minutes.map{|mm| mm[0][1]})
  end

  private

  def menu_name
    return :machine_minutes
  end
end
