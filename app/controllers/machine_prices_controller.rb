class MachinePricesController < ApplicationController
  def show_type
    @machine_type = MachineType.find(params[:machine_type_id])
    @machine_price = MachinePriceHeader.show_type(@machine_type, Date.today)
    @work_kinds = @machine_type.work_kinds
  end

  def new
    @adjusts = Adjust.all
    if params[:machine_id]
      @machine_price = MachinePriceHeader.new(machine_id: params[:machine_id], validated_at: Date.today)
      @work_kinds = Machine.find(params[:machine_id]).machine_type.work_kinds
    else
      @machine_price = MachinePriceHeader.new(machine_type_id: params[:machine_type_id], validated_at: Date.today)
      @work_kinds = MachineType.find(params[:machine_type_id]).work_kinds
    end
  end
end
