class Lands::OwnersController < ApplicationController
  include PermitChecker
  before_action :set_land, only: [:index, :create]

  def index
    @land.land_homes.build
    render partial: "lands/homes"
  end

  def create
    @land.update(owners_params)
  end

  def destroy
    LandHome.where(land_id: params[:land_id], owner_flag: true).destroy_all
  end

  private

  def set_land
    @land = Land.find(params[:land_id])
    @owner_flag = true
  end

  def owners_params
    params
    .require(:land)
    .permit(
      land_homes_attributes: [:home_id, :place, :area, :_destroy, :id, :manager_flag, :owner_flag]
    )
  end
end
