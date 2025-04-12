class MachinesController < ApplicationController
  include PermitChecker
  before_action :set_machine, only: [:edit, :update, :destroy]
  before_action :set_masters, only: [:new, :create, :edit, :update]

  def index
    @machines = MachineDecorator.decorate_collection(Machine.includes(:owner).usual.page(params[:page]))
  end

  def new
    @machine = Machine.new
  end

  def edit; end

  def create
    @machine = Machine.new(machine_params)
    if @machine.save
      redirect_to machines_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    if @machine.update(machine_params)
      redirect_to machines_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @machine.destroy
    redirect_to machines_path, status: :see_other
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
    params.expect(machine:
          [:name, :display_order, :validity_start_at, :validity_end_at,
           :machine_type_id, :home_id, :number, :diesel_flag])
  end
end
