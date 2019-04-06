class WorkKindsController < ApplicationController
  include PermitChecker
  before_action :set_work_kind, only: [:edit, :update, :destroy]
  before_action :set_others, only: [:new, :create, :edit, :update]

  def index
    @work_kinds = WorkKind.usual.page(params[:page])
  end

  def new
    @work_kind = WorkKind.new(price: current_system.default_price)
  end

  def edit
  end

  def create
    @work_kind = WorkKind.new(work_kind_params)
    if @work_kind.save
      update_others
      redirect_to work_kinds_path
    else
      render action: :new
    end
  end

  def update
    if @work_kind.update(work_kind_params)
      update_others
      redirect_to work_kinds_path
    else
      render action: :edit
    end
  end

  def destroy
    @work_kind.destroy
    redirect_to work_kinds_path
  end

  private

  def set_work_kind
    @work_kind = WorkKind.find(params[:id])
  end

  def work_kind_params
    params.require(:work_kind).permit(
      :name,
      :display_order,
      :price,
      :land_flag,
      :broccoli_mark
    )
  end

  def set_others
    @work_types = WorkType.categories
    @machine_types = MachineType.order(:display_order, :id)
    @chemical_types = ChemicalType.order(:display_order, :id)
  end

  def update_others
    @work_kind.work_types = params[:work_types] ? WorkType.find(params[:work_types]) : []
    @work_kind.machine_types = params[:machine_types] ? MachineType.find(params[:machine_types]) : []
    @work_kind.chemical_types = params[:chemical_types] ? ChemicalType.find(params[:chemical_types]) : []
  end
end
