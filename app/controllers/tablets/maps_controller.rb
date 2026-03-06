class Tablets::MapsController < TabletsController
  helper GmapHelper

  def index
    @target = Time.zone.today
    @lands = Land.regionable.expiry(@target).includes(:owner)
  end
end
