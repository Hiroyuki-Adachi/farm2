class CostTypesController < ApplicationController
  include PermitManager
  before_action :set_cost_type, only: [:edit, :update, :destroy]
  before_action :set_work_kinds, only: [:new, :edit, :create, :update, :destroy]

  def index
    @cost_types = CostType.usual
  end

  def new
    @cost_type = CostType.new
  end

  def create
    @cost_type = CostType.new(cost_type_params)
    if @cost_type.save
      redirect_to cost_types_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    if @cost_type.update(cost_type_params)
      redirect_to cost_types_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def edit; end

  def destroy
    @cost_type.destroy
    redirect_to cost_types_path, status: :see_other
  end

  private

  def set_cost_type
    @cost_type = CostType.find(params[:id])
  end

  def set_work_kinds
    @work_kinds = WorkKind.usual
  end

  def cost_type_params
    params.expect(cost_type: [:name, :phonetic, :display_order, {work_kind_ids: []}])
  end
end
