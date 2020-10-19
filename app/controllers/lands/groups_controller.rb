class Lands::GroupsController < ApplicationController
  include PermitChecker
  before_action :set_land, only: [:edit, :update, :destroy]
  before_action :set_places, only: [:new, :create, :edit, :update]
  before_action :set_other_lands, only: [:new, :edit]

  helper GmapHelper

  def index
    @lands = Land.group_list
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
      Land.update_members(@land.id, params[:members])
      redirect_to lands_groups_path
    else
      render action: :new
    end
  end

  def update
    if @land.update(land_params)
      Land.update_members(@land.id, params[:members])
      redirect_to lands_groups_path
    else
      render action: :edit
    end
  end

  def destroy
    @land.destroy
    redirect_to lands_groups_path
  end

  def autocomplete
    render json: Land.autocomplete_groups(params[:term])
  end

  private

  def set_land
    @land = Land.find(params[:id])
    throw(:abort) unless @land.group_flag
  end

  def land_params
    params.require(:land)
          .permit(
            :place,
            :display_order,
            :land_place_id,
            :broccoli_mark,
            :region
          )
          .merge(area: 0, group_flag: true)
  end

  def set_places
    @places = LandPlace.usual
  end

  def set_other_lands
    @other_lands = Land.regionable.where.not(id: @land)
  end
end
