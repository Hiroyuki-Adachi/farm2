class ExpenseTypesController < ApplicationController
  include PermitManager
  before_action :set_expense_type, only: [:edit, :update, :destroy]

  def index
    @expense_types = ExpenseType.usual
  end

  def new
    @expense_type = ExpenseType.new
  end

  def edit
  end

  def create
    @expense_type = ExpenseType.new(expense_type_params)
    if @expense_type.save
      redirect_to expense_types_path
    else
      render action: :new
    end
  end

  def update
    if @expense_type.update(expense_type_params)
      redirect_to expense_types_path
    else
      render action: :edit
    end
  end

  def destroy
    @expense_type.destroy
    redirect_to expense_types_path
  end

  private

  def set_work_type
    @expense_type = ExpenseType.find(params[:id])
  end

  def expense_type_params
    params
      .require(:expense_type)
      .permit(:name, :display_order, :sales_flag, :chemical_flag, :other_flag)
  end
end
