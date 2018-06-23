class ExpensesController < ApplicationController
  include PermitManager
  before_action :set_expense, only: [:edit, :update, :destroy]
  before_action :set_work_type, only: [:new, :create, :edit, :update]

  def index
    @expenses = ExpenseDecorator.decorate_collection(Expense.usual(current_term).page(params[:page]))
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.new(expense_params)
    if @expense.save
      redirect_to expenses_path
    else
      render action: :new
    end
  end

  def edit
  end

  def update
    if @expense.update(expense_params)
      redirect_to expenses_path
    else
      render action: :edit
    end
  end

  def destroy
    @expense.destroy
    redirect_to expenses_path
  end

  private

  def set_expense
    @expense = Expense.find(params[:id])
  end

  def expense_params
    params.require(:expense).permit(
      :term, :payed_on, :content, :amount,
      expense_work_types_attributes: [:id, :work_type_id, :rate, :_destroy]
    )
  end

  def set_work_type
    @work_types = WorkType.land
  end
end
