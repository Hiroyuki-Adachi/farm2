class ChemicalCostsController < ApplicationController
  include PermitManager

  def index
    @chemical_terms = ChemicalTerm.usual(current_term)
    @work_types = WorkType.land
    @chemical_work_types = ChemicalWorkType.where(chemical_term_id: @chemical_terms.ids)
  end

  def create
  end
end
