class LandsController < ApplicationController
  include PermitChecker
  before_action :set_land, only: [:edit, :update, :destroy]
  before_action :set_homes, only: [:new, :create, :edit, :update]
  before_action :set_places, only: [:new, :create, :edit, :update]
  before_action :set_other_lands, only: [:new, :edit]
  helper GmapHelper

  def index
    @homes = LandDecorator.homes
    @home_id = params[:home_id]
    @sum_areas = (@home_id ? Land.usual.where(owner_id: @home_id) : Land.usual).sum(:area)
    @lands = @home_id ? Land.list.where(owner_id: @home_id) : Land.list
    @lands = LandDecorator.decorate_collection(@lands.page(params[:page]))
  end

  def new
    @land = Land.new
  end

  def edit
  end

  def create
    @land = Land.new(land_params)
    if @land.save
      redirect_to lands_path
    else
      render action: :new
    end
  end

  def update
    if @land.update(land_params)
      redirect_to lands_path
    else
      render action: :edit
    end
  end

  def destroy
    @land.destroy
    redirect_to lands_path
  end

  private

  def set_land
    @land = Land.find(params[:id])
    throw(:abort) if @land.group_flag
  end

  def set_homes
    @homes = Home.landable.includes(:holder)
  end

  def set_places
    @places = LandPlace.usual
  end

  def set_other_lands
    @other_lands = Land.regionable.where.not(id: @land).expiry(Date.today)
  end

  def land_params
    params.require(:land)
          .permit(
            :place,
            :owner_id,
            :manager_id,
            :area,
            :target_flag,
            :display_order,
            :land_place_id,
            :reg_area,
            :broccoli_mark,
            :region,
            :start_on,
            :end_on
          )
  end
end
