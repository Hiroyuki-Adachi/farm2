class PersonalInformations::MapsController < PersonalInformationsController
  helper GmapHelper

  def index
    @target = Time.zone.today
    lands = Land.for_organization(current_organization).regionable.expiry(@target)
    @costs = LandCost.usual(lands, @target).includes(land: [:owner, { manager: :holder }], work_type: [])
    @work_types = WorkType.land.by_term(current_organization.get_term(@target))
  end
end
