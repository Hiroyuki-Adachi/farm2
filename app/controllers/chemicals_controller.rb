class ChemicalsController < ApplicationController
  include PermitChecker
  before_action :set_chemical, only: [:edit, :update, :destroy]
  before_action :set_chemical_types, only: [:new, :create, :edit, :update]

  def index
    @chemicals = ChemicalDecorator.decorate_collection(Chemical.list)
  end

  def new
    @chemical = Chemical.new
  end

  def edit
  end

  def create
    @chemical = Chemical.new(chemical_params)
    if @chemical.save
      redirect_to chemicals_path
    else
      render action: :new
    end
  end

  def update
    if @chemical.update(chemical_params)
      redirect_to chemicals_path
    else
      render action: :edit
    end
  end

  def destroy
    @chemical.destroy
    redirect_to chemicals_path
  end

  private

  def set_chemical
    @chemical = Chemical.find(params[:id])
    @chemical.term = @term
  end

  def set_chemical_types
    @chemical_types = ChemicalType.all.order(:display_order)
  end

  def chemical_params
    params.require(:chemical).permit(:name, :display_order, :chemical_type_id, :this_term_flag, :unit).merge(term: @term)
  end
end
