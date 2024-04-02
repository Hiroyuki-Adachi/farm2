class LandPlacesController < ApplicationController
  include PermitManager
  before_action :set_land_place, only: [:edit, :update, :destroy]

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
      render action: :new, status: :unprocessable_entity
    end
  end

  def update
    if @land_place.update(land_place_params)
      redirect_to land_places_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @land_place.destroy
    redirect_to land_places_path, status: :see_other
  end

  private

  def set_land_place
    @land_place = LandPlace.find(params[:id])
  end

  def land_place_params
    params.require(:land_place).permit(:name, :display_order, :remarks)
  end
end
