class SeedlingCostsController < ApplicationController
  include PermitManager

  def index
    chemical_term = ChemicalTerm.find_by(chemical_id: current_system.seedling_chemical_id, term: current_term)
    @chemical_terms = ChemicalTerm.usual(current_term)
    @chemical_price = chemical_term&.price
    @work_types = WorkType.land
    @seedlings = Seedling.usual(current_term, @work_types)
    @lands = LandCost.total(current_term)
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

  private

  def system_params
    params.require(:system).permit(:seedling_price, :seedling_chemical_id)
  end

  def seedling_params(seedling)
    seedling.permit(:term, :work_type_id, :seedling_quantity, :soil_quantity, :seed_cost)
  end
end
