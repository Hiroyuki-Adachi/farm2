class Tablets::HarvestWholeCropsController < TabletsController
  include PermitManager

  helper GmapHelper

  def map
    @wcs_land_summaries = HarvestWholeCrops::MapService.call(organization: current_organization, term: current_term)
    @lands = Land.for_organization(current_organization).regionable
      .includes(:owner)
      .where(id: @wcs_land_summaries.keys)
      .usual_order
  end
end
