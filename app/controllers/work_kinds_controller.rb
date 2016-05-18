class WorkKindsController < ApplicationController
  before_action :set_work_kind, only: [:edit, :update, :destroy]
  before_action :set_others, only: [:new, :edit]

  def index
    @work_kinds = WorkKind.usual
  end

  def new
  end

  def edit
  end

  def create
  end

  def update
  end

  def destroy
  end
  
  private
  def set_work_kind
    @work_kind = WorkKind.find(params[:id])
  end
  
  def work_kind_params
    return params.require(:work_kind).permit(:name, :display_order, :price)
  end
  
  def set_others
    @work_types = WorkType.categories
    @machine_types = MachineType.order(:display_order, :id)
    @chemical_types = ChemicalType.order(:display_order, :id)
  end
  
end
