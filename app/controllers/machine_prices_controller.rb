class MachinePricesController < ApplicationController
  def show_type
    @machine_type = MachineType.find(params[:machine_type_id])
    @work_kinds = @machine_type.work_kinds
    @machine_prices = MachinePrice.where(machine_type_id: @machine_type)
    if @machine_prices.exists?
      @machine_prices = @machine_prices.where(validity_at: @machine_prices.maximum(:validity_at))
    end
  end
end
