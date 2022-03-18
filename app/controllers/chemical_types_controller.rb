class ChemicalTypesController < ApplicationController
  include PermitChecker
  before_action :set_chemical_type, only: [:edit, :update, :destroy]
  before_action :set_work_kinds, only: [:new, :create, :edit, :update]

  def index
    @chemical_types = ChemicalType.includes(:chemicals).all.order(:display_order)
    @chemical_types = ChemicalTypeDecorator.decorate_collection(@chemical_types)
  end

  def new
    @chemical_type = ChemicalType.new
  end

  def edit
  end

  def create
    @chemical_type = ChemicalType.new(chemical_type_params)

    if @chemical_type.save
      update_work_kinds
      redirect_to chemical_types_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    if @chemical_type.update(chemical_type_params)
      update_work_kinds
      redirect_to chemical_types_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chemical_type.destroy
    redirect_to chemical_types_path, status: :see_other
  end

  private

  def set_chemical_type
    @chemical_type = ChemicalType.includes(:work_kinds).find(params[:id])
  end

  def set_work_kinds
    @work_kinds = WorkKind.all.order(:display_order)
  end

  def chemical_type_params
    return params.require(:chemical_type).permit(:name, :display_order)
  end

  def update_work_kinds
    @chemical_type.work_kinds = params[:work_kinds] ? WorkKind.find(params[:work_kinds]) : []
  end
end
