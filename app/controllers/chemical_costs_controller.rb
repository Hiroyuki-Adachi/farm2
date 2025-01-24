class ChemicalCostsController < ApplicationController
  include PermitManager
  before_action :set_work_types, only: [:index]
  before_action :set_chemical_work_type, only: [:edit, :update]
  before_action :destroy_chemical_work_type, only: [:create]

  def index
    @chemical_terms = ChemicalTerm.land.usual(current_term)
    @chemical_work_types = ChemicalWorkType.by_chemical_terms(@chemical_terms).includes(:chemical_term, :work_type)
  end

  def new
    @chemical_work_type = ChemicalWorkType.new(
      chemical_term_id: params[:chemical_term_id],
      work_type_id: params[:work_type_id],
      quantity: 1
    )
  end

  def edit; end

  def create
    @chemical_work_type = ChemicalWorkType.new(chemical_work_type_params)
    if params[:regist]
      @chemical_work_type.save! 
    else
      @chemical_work_type.quantity = 0
    end
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.replace(
          "td_#{@chemical_work_type.chemical_term_id}_#{@chemical_work_type.work_type_id}", 
          partial: 'show', locals: {chemical_work_type: @chemical_work_type}
        )
      end
    end
  end

  def update
    @chemical_work_type.update(chemical_work_type_params) if params[:regist]
    respond_to do |format|
      format.turbo_stream do 
        render turbo_stream: turbo_stream.replace(
          "td_#{@chemical_work_type.chemical_term_id}_#{@chemical_work_type.work_type_id}", 
          partial: 'show', locals: {chemical_work_type: @chemical_work_type}
        )
      end
    end
  end

  def import
    render json: Expense.chemical_prices(current_term)
  end

  private

  def set_work_types
    @work_types = WorkType.land.where(work_flag: true).by_term(current_term)
  end

  def set_chemical_work_type
    @chemical_work_type = ChemicalWorkType.find(params[:id])
  end

  def destroy_chemical_work_type
    ChemicalWorkType.where(
      chemical_term_id: chemical_work_type_params[:chemical_term_id],
      work_type_id: chemical_work_type_params[:work_type_id]
    ).destroy_all
  end

  def chemical_work_type_params
    params.expect(chemical_work_type: [:chemical_term_id, :work_type_id, :quantity])
  end
end
