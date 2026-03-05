class Tablets::MapsController < ApplicationController
  helper GmapHelper
  layout "tablets"

  def index
    @target = Time.zone.today
    @lands = Land.regionable.expiry(@target).includes(:owner)
  end
end
