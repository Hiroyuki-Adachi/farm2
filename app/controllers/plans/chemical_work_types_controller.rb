class Plans::ChemicalWorkTypesController < ApplicationController
  include PermitManager

  def new
    @plan_work_types = PlanWorkType.usual
    @chemical_terms = ChemicalTerm.usual(current_term + 1)
    @chemical_work_types = ChemicalWorkType.by_chemical_terms(@chemical_terms)
  end

  private

  def menu_name
    return :plan_chemicals
  end
end
