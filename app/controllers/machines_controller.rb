class MachinesController < ApplicationController
  before_action :set_machine, only: [:edit, :update, :destroy]
  before_action :set_masters, only: [:new, :create, :edit, :update]

  def index
    @machines = MachineDecorator.decorate_collection(Machine.usual.page(params[:page]))
  end

  def new
    @machine = Machine.new
  end

  def edit
  end

  def create
    @machine = Machine.new(machine_params)
    if @machine.save
      redirect_to machines_path
    else
      render action: :new
    end
  end

  def update
    if @machine.update(machine_params)
      redirect_to machines_path
    else
      render action: :edit
    end
  end

  def destroy
    @machine.destroy
    redirect_to machines_path
  end

  private

  def set_machine
    @machine = Machine.find(params[:id])
  end

  def set_masters
    @homes = Home.machine_owners
    @machine_types = MachineType.usual
  end

  def machine_params
    return params.require(:machine).permit(:name, :display_order, :validity_start_at, :validity_end_at, :machine_type_id, :home_id)
  end
end
