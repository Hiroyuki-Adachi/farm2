class PersonalInformations::MapsController < PersonalInformationsController
  helper GmapHelper

  def index
    @target = Time.zone.today
    @costs = LandCost.usual(Land.regionable.expiry(@target), @target).includes(land: [:owner, {manager: :holder}], work_type: [])
    @work_types = WorkType.land.by_term(current_organization.get_term(@target))
  end
end
