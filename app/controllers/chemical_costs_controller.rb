class ChemicalCostsController < ApplicationController
  include PermitManager
  before_action :set_work_types, only: [:index, :edit]
  before_action :set_chemical_term, only: [:edit]

  def index
    @chemical_terms = ChemicalTerm.land.usual(current_term)
    @chemical_work_types = ChemicalWorkType.by_chemical_terms(@chemical_terms).includes(:chemical_term, :work_type)
  end

  def edit
    @chemical_work_types = ChemicalWorkType.by_chemical_term(@chemical_term)
    render layout: false, content_type: 'text/vnd.turbo-stream.html'
  end

  def create
    ActiveRecord::Base.transaction do
      ChemicalTerm.regist_price(params[:chemical_terms])
      ChemicalWorkType.regist_quantity(params[:chemical_work_types])
    end
    redirect_to chemical_costs_path
  end

  def import
    render json: Expense.chemical_prices(current_term)
  end

  private

  def set_work_types
    @work_types = WorkType.land.where(work_flag: true).by_term(current_term)
  end

  def set_chemical_term
    @chemical_term = ChemicalTerm.find(params[:id])
  end
end
