class LandCostsController < ApplicationController
  include PermitManager

  def index
    @work_types = WorkType.land
    if request.xhr?
      @lands = Land.where(land_place_id: params[:land_place_id]).usual
      @costs = LandCost.usual(@lands, @term)
      respond_to do |format|
        format.js
      end
    else
      @land_places = LandPlace.usual
      @lands = Land.where(land_place_id: @land_places.first).usual
      @costs = LandCost.usual(@lands, @term)
      respond_to do |format|
        format.html
      end
    end
  end

  def create
  end
end
