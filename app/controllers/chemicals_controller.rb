class ChemicalsController < ApplicationController
  include PermitChecker
  before_action :set_chemical, only: [:edit, :update, :destroy]
  before_action :set_chemical_types, only: [:new, :create, :edit, :update]
  before_action :set_base_units, only: [:new, :edit]

  def index
    @chemicals = ChemicalDecorator.decorate_collection(Chemical.list.page(params[:page]))
  end

  def new
    @chemical = Chemical.new
  end

  def edit; end

  def create
    @chemical = Chemical.new(chemical_params)
    if @chemical.save
      redirect_to chemicals_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    if @chemical.update(chemical_params)
      redirect_to chemicals_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chemical.destroy
    redirect_to chemicals_path, status: :see_other
  end

  private

  def set_chemical
    @chemical = Chemical.find(params[:id])
    @chemical.term = current_term
  end

  def set_base_units
    @base_units = BaseUnit.all
  end

  def set_chemical_types
    @chemical_types = ChemicalType.order(:display_order)
  end

  def chemical_params
    params.require(:chemical)
          .permit(
            :name, 
            :display_order, 
            :chemical_type_id, 
            :this_term_flag, 
            :unit, 
            :phonetic,
            :base_quantity,
            :carton_quantity,
            :carton_unit,
            :base_unit_id,
            :aqueous_flag,
            :stock_quantity,
            :stock_unit,
            :url
          )
          .merge(term: current_term)
  end
end
