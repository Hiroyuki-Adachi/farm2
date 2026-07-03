class Statistics::MachinesController < ApplicationController
  include PermitManager

  def index
    @systems, machines, hours = StatisticsMachineQuery.new(current_organization).call
    @machines = Statistics::MachineDecorator.decorate_collection(machines, context: { hours: hours })
  end

  private

  def menu_name
    :statistics_machines
  end
end
