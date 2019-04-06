class BroccoliSalesController < ApplicationController
  include PermitChecker

  def index
    @works = Work.for_broccoli(current_organization).by_term(current_term)
  end

  def create
    WorkBroccoli.regist_sales(work_broccoli_params)
    redirect_to broccoli_sales_path
  end

  private

  def work_broccoli_params
    params.permit(work_broccoli: [:id, :shipped_on, :sale, :cost, :work_id])
  end
end
