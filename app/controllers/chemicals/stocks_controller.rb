class Chemicals::StocksController < ApplicationController
  include PermitManager

  def index
  end

  def load
    @chemicals = ChemicalTerm.by_type(params[:term], params[:chemical_type_id])
    render action: :load, layout: false
  end

  def search
    @chemical_term = ChemicalTerm.find(params[:chemical_id])
    @target_system = System.find_by(term: @chemical_term.term, organization_id: current_organization.id)
    ChemicalStock.refresh(@chemical_term.chemical_id)
    @stocks = ChemicalStock.usual(@chemical_term.chemical_id).where(stock_on: @target_system.start_date..@target_system.end_date)
    @stocks = ChemicalStockDecorator.decorate_collection(@stocks)
    render action: :search, layout: false
  end
end
