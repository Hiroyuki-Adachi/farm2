class Chemicals::StocksController < ApplicationController
  include PermitManager
  before_action :set_chemical_term, only: [:search, :new, :edit]
  before_action :set_stock, only: [:edit, :update, :destroy]

  def index
  end

  def load
    @chemicals = ChemicalTerm.by_type(params[:term], params[:chemical_type_id])
    render action: :load, layout: false
  end

  def search
    ChemicalStock.refresh(@chemical_term.chemical_id)
    @stocks = ChemicalStock.usual(@chemical_term.chemical_id).where(stock_on: @target_system.start_date..@target_system.end_date)
    @stocks = ChemicalStockDecorator.decorate_collection(@stocks)
    render action: :search, layout: false
  end

  def new
    @stock = ChemicalStock.new
    render :form, layout: false
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_chemical_term
    @chemical_term = ChemicalTerm.find(params[:chemical_id])
    @target_system = System.find_by(term: @chemical_term.term, organization_id: current_organization.id)
  end

  def set_stock
    @stock = ChemicalStock.find(params[:id])
  end
end
