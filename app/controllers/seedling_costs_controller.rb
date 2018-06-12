class SeedlingCostsController < ApplicationController
  include PermitManager

  def index
    @chemical_terms = ChemicalTerm.usual(current_term)
    @chemical_price = ChemicalTerm.find_by(chemical_id: current_system.seedling_chemical_id, term: current_term)&.price
    @work_types = WorkType.land
    @seedlings = Seedling.usual(current_term, @work_types)
  end

  def create
  end
end
