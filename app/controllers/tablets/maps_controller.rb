class Tablets::MapsController < TabletsController
  helper GmapHelper

  def index
    @target = Time.zone.today
    @lands = Land.for_organization(current_organization).regionable.expiry(@target).includes(:owner)
  end
end
