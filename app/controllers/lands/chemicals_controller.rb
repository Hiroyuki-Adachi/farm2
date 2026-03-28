class Lands::ChemicalsController < ApplicationController
  include PermitUser
  helper GmapHelper

  def index
    @chemical_types = ChemicalType.usual.where(id: current_organization.rice_planting.chemical_types.select(:id))
    @selected_chemical_type_id = selected_chemical_type_id
    @land_chemical_summaries = Lands::ChemicalMapService.call(
      term: current_term,
      work_kind_id: current_organization.rice_planting_id,
      chemical_type_id: @selected_chemical_type_id
    )
    @lands = Land.regionable
      .includes(:owner)
      .where(id: target_land_ids)
      .usual_order
  end

  private

  def target_land_ids
    WorkLand.joins(:work)
      .where(works: { term: current_term, work_kind_id: current_organization.rice_planting_id })
      .select(:land_id)
      .distinct
  end

  def selected_chemical_type_id
    selected_id = params[:chemical_type_id].to_i
    return @chemical_types.first&.id if selected_id.zero?

    @chemical_types.find_by(id: selected_id)&.id || @chemical_types.first&.id
  end

  def menu_name
    return :lands_chemicals
  end
end
