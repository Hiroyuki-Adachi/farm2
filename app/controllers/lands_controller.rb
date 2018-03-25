class LandsController < ApplicationController
  before_action :set_land, only: [:edit, :update, :destroy]
  before_action :set_homes, only: [:new, :create, :edit, :update]

  def index
    @homes = LandDecorator.homes
    @home_id = params[:home_id]
    @sum_areas = @home_id.present? ? Land.usual.where(owner_id: @home_id).sum(:area) : Land.usual.sum(:area)
    @lands = @home_id.present? ? Land.list.where(owner_id: @home_id) : Land.list
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
  end

  def set_homes
    @homes = Home.list
  end

  def land_params
    return params.require(:land).permit(:place, :owner_id, :manager_id, :area, :target_flag, :display_order)
  end
end
