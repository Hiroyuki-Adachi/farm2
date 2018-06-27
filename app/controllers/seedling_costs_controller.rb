class SeedlingCostsController < ApplicationController
  include PermitManager
  before_action :set_seedling, only: [:edit, :update]

  def index
    chemical_term = ChemicalTerm.find_by(chemical_id: current_system.seedling_chemical_id, term: current_term)
    @chemical_terms = ChemicalTerm.includes(:chemical).usual(current_term)
    @chemical_price = chemical_term&.price
    @work_types = WorkType.land
    @seedlings = Seedling.usual(current_term, @work_types)
    @seedling_quantities = SeedlingHome.total(@seedlings)
    @lands = LandCost.total(Time.zone.today)
  end

  def create
    chemical_term = ChemicalTerm.find_by(chemical_id: system_params[:seedling_chemical_id], term: current_term)
    ActiveRecord::Base.transaction do
      current_system.update(system_params)
      chemical_term.update(price: params[:chemical][:price])
      params[:seedlings].each do |seedling|
        if seedling[:id].present?
          Seedling.update(seedling[:id], seedling_params(seedling))
        else
          Seedling.create(seedling_params(seedling))
        end
      end
    end
    redirect_to seedling_costs_path
  end

  def edit
    @homes = Home.usual
    @seedling.seedling_homes.build
  end

  def update
    if @seedling.update(seedling_home_params)
      redirect_to edit_seedling_cost_path(seedling_id: @seedling.id)
    else
      render action: :edit
    end
  end

  private

  def set_seedling
    @seedling = Seedling.find(params[:seedling_id])
  end

  def system_params
    params.require(:system).permit(:seedling_price, :seedling_chemical_id)
  end

  def seedling_params(seedling)
    seedling.permit(:term, :work_type_id, :soil_quantity, :seed_cost)
  end

  def seedling_home_params
    params.require(:seedling).permit(seedling_homes_attributes: [:id, :home_id, :quantity, :_destroy])
  end
end
