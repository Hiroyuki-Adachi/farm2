class Tablets::HarvestWholeCropsController < TabletsController
  include PermitManager

  helper GmapHelper

  def map
    terms = [previous_term, current_term]
    @term_names = terms.zip(System.term_names_for(current_organization, terms)).to_h
    @selected_term = params[:term].to_s == previous_term.to_s ? previous_term : current_term
    @wcs_land_summaries = HarvestWholeCrops::MapService.call(organization: current_organization, term: @selected_term)
    @lands = Land.for_organization(current_organization).regionable
      .includes(:owner)
      .where(id: @wcs_land_summaries.keys)
      .usual_order
  end
end
