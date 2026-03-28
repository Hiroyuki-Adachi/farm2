class Lands::ChemicalsController < ApplicationController
  include PermitUser

  def index
    @chemical_types = ChemicalType.usual.where(id: current_organization.rice_planting.chemical_types.select(:id))
    @selected_chemical_type_id = selected_chemical_type_id
  end

  private

  def selected_chemical_type_id
    selected_id = params[:chemical_type_id].to_i
    return @chemical_types.first&.id if selected_id.zero?

    @chemical_types.find_by(id: selected_id)&.id || @chemical_types.first&.id
  end

  def menu_name
    return :lands_chemicals
  end
end
