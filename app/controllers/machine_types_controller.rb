class MachineTypesController < ApplicationController
  include PermitChecker
  before_action :set_machine_type, only: [:edit, :update, :destroy]
  before_action :set_work_kinds, only: [:new, :create, :edit, :update]

  def index
    @machine_types = MachineType.includes(:machines).order(:display_order)
  end

  def new
    @machine_type = MachineType.new
  end

  def edit; end

  def create
    @machine_type = MachineType.new(machine_type_params)

    if @machine_type.save
      update_work_kinds
      redirect_to machine_types_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @machine_type.update(machine_type_params)
      update_work_kinds
      redirect_to machine_types_path
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @machine_type.destroy
    redirect_to machine_types_path, status: :see_other
  end

  private

  def set_machine_type
    @machine_type = MachineType.includes(:work_kinds).find(params[:id])
  end

  def set_work_kinds
    @work_kinds = WorkKind.usual
  end

  def machine_type_params
    params.expect(machine_type: [:name, :display_order, :code])
  end

  def update_work_kinds
    @machine_type.work_kinds = params[:work_kinds] ? WorkKind.find(params[:work_kinds]) : []
  end
end
