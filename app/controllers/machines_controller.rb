class MachinesController < ApplicationController
  include PermitChecker
  include ReturnToIndex
  before_action :set_machine, only: [:edit, :update, :destroy]
  before_action :set_masters, only: [:new, :create, :edit, :update]
  keeps_index_return_to path_method: :machines_path

  def index
    @machines = MachineDecorator.decorate_collection(
      Machine.for_organization(current_organization).includes(:owner).usual.page(params[:page])
    )
  end

  def new
    @machine = Machine.new
  end

  def edit; end

  def create
    @machine = Machine.new(machine_params)
    @machine.owner = machine_owners.find(machine_params[:home_id])
    if @machine.save
      redirect_to machines_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    @machine.owner = machine_owners.find(machine_params[:home_id])
    if @machine.update(machine_params)
      redirect_to @return_to
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @machine.discard
    redirect_to @return_to, status: :see_other
  end

  private

  def set_machine
    @machine = Machine.for_organization(current_organization).find(params[:id])
  end

  def set_masters
    @homes = machine_owners
    @machine_types = MachineType.usual
  end

  def machine_params
    params.expect(machine:
          [:name, :display_order, :validity_start_at, :validity_end_at,
           :machine_type_id, :home_id, :number, :diesel_flag])
  end

  def machine_owners
    Home.for_organization(current_organization).machine_owners
  end
end
