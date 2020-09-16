class Plans::ChemicalsController < ApplicationController
  include PermitManager

  def new
    @chemicals = Chemical.by_work_kind(current_organization.rice_planting_id)
  end

  def create
    ChemicalTerm.create_for_plans(params, current_term + 1)
    redirect_to new_plans_chemical_path
  end

  private

  def menu_name
    return :plan_chemicals
  end
end
