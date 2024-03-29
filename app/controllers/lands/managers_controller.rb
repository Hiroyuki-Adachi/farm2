class Lands::ManagersController < ApplicationController
  include PermitChecker
  before_action :set_land, only: [:index, :create]

  def index
    @land.land_homes.where(manager_flag: true).build
    render partial: "lands/homes"
  end

  def create
    @land.update(managers_params)
  end

  def destroy
    LandHome.where(land_id: params[:land_id], manager_flag: true).destroy_all
  end

  private

  def set_land
    @land = Land.find(params[:land_id])
    @manager_flag = true
    @owner_flag = false
  end

  def managers_params
    params
    .require(:land)
    .permit(
      land_homes_attributes: [:home_id, :place, :area, :_destroy, :id, :manager_flag, :owner_flag]
    )
  end
end
