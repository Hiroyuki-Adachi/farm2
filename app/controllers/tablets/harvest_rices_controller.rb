class Tablets::HarvestRicesController < TabletsController
  include PermitManager

  helper GmapHelper

  def map
    set_terms
    system = @selected_term == current_term ? current_system : previous_system
    @rice_land_summaries = system ? HarvestRices::MapService.call(organization: current_organization, system: system) : {}
    @lands = Land.for_organization(current_organization).regionable
      .includes(:owner)
      .where(id: @rice_land_summaries.keys)
      .usual_order
  end

  private

  def set_terms
    terms = [previous_term, current_term]
    @term_names = terms.zip(System.term_names_for(current_organization, terms)).to_h
    @selected_term = params[:term].to_s == previous_term.to_s ? previous_term : current_term
  end
end
