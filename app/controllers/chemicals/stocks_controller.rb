class Chemicals::StocksController < ApplicationController
  include PermitManager
  before_action :set_chemical_term, only: [:search, :new, :edit, :create, :update]
  before_action :set_stock, only: [:edit, :update, :destroy]

  def index; end

  def load
    @chemicals = ChemicalTerm.by_type(params[:term], params[:chemical_type_id])
    render action: :load, layout: false
  end

  def search
    ChemicalStock.refresh(current_organization.id, @chemical_term.chemical_id)
    @stocks = ChemicalStock.usual(@chemical_term.chemical_id).where(stock_on: @target_system.start_date..@target_system.end_date)
    @stocks = ChemicalStockDecorator.decorate_collection(@stocks)
    render action: :search, layout: false
  end

  def new
    @stock = ChemicalStock.new
    render :form, layout: false
  end

  def create
    @stock = ChemicalStock.new(stock_params)
    if @stock.save
      render json: nil, status: :ok
    else
      render json: nil, status: :internal_server_error
    end
  end

  def edit
    render :form, layout: false
  end

  def update
    if @stock.update(stock_params)
      render json: nil, status: :ok
    else
      render json: nil, status: :internal_server_error
    end
  end

  def destroy
    @stock.destroy
    render json: nil, status: :ok
  end

  private

  def stock_params
    params
      .require(:chemical_stock)
      .permit(
        :stock_on,
        :name,
        :stored,
        :shipping
      )
      .merge(chemical_id: @chemical_term.chemical_id)
  end

  def set_chemical_term
    @chemical_term = ChemicalTerm.find(params[:chemical_id])
    @target_system = System.find_by(term: @chemical_term.term, organization_id: current_organization.id)
  end

  def set_stock
    @stock = ChemicalStock.find(params[:id])
  end
end
