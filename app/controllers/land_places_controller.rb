class LandPlacesController < ApplicationController
  include PermitManager
  include ReturnToIndex
  before_action :set_land_place, only: [:edit, :update, :destroy]
  keeps_index_return_to path_method: :land_places_path

  def index
    @land_places = LandPlace.usual
  end

  def new
    @land_place = LandPlace.new
  end

  def edit; end

  def create
    @land_place = LandPlace.new(land_place_params)

    if @land_place.save
      redirect_to land_places_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @land_place.update(land_place_params)
      redirect_to @return_to
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @land_place.discard
    redirect_to @return_to, status: :see_other
  end

  private

  def set_land_place
    @land_place = LandPlace.find(params[:id])
  end

  def land_place_params
    params.expect(land_place: [:name, :display_order, :remarks])
  end
end
