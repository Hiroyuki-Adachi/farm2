class LandsController < ApplicationController
  include PermitChecker
  include ReturnToIndex

  before_action :set_land, only: [:edit, :update, :destroy]
  before_action :set_homes, only: [:new, :create, :edit, :update]
  before_action :set_places, only: [:new, :create, :edit, :update]
  before_action :set_other_lands, only: [:new, :edit]
  keeps_index_return_to path_method: :lands_path
  helper GmapHelper

  def index
    base = Land.for_organization(current_organization)
    @homes = LandDecorator.homes(current_organization)
    @home_id = params[:home_id]
    @sum_areas = (@home_id ? base.usual.where(owner_id: @home_id) : base.usual).sum(:area)

    respond_to do |format|
      format.html do
        @lands = @home_id ? base.list.where(owner_id: @home_id) : base.list
        @lands = LandDecorator.decorate_collection(@lands.page(params[:page]))
      end
      format.csv do
        @lands = base.usual.expiry
        @lands = @lands.where(owner_id: @home_id) if @home_id.present?
        @lands = @lands.includes(owner: :holder)
        send_data render_to_string, filename: "lands_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv", type: :csv
      end
    end
  end

  def new
    @land = Land.new
  end

  def edit; end

  def create
    @land = Land.new(land_params.merge(organization_id: current_organization.id))
    if @land.save
      redirect_to lands_path
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @land.update(land_params)
      redirect_to @return_to, status: :see_other
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @land.discard
    redirect_to @return_to, status: :see_other
  end

  private

  def set_land
    @land = Land.for_organization(current_organization).find_by(id: params[:id])
    return to_error_path unless @land

    throw(:abort) if @land.group_flag
  end

  def set_homes
    @homes = Home.for_organization(current_organization).landable.includes(:holder)
  end

  def set_places
    @places = LandPlace.usual
  end

  def set_other_lands
    @other_lands = Land.for_organization(current_organization).regionable.where.not(id: @land).expiry(Time.zone.today)
  end

  def land_params
    params.expect(land:
      [
        :place,
        :owner_id,
        :manager_id,
        :area,
        :target_flag,
        :land_place_id,
        :reg_area,
        :broccoli_mark,
        :region,
        :start_on,
        :end_on,
        :peasant_start_term,
        :peasant_end_term,
        :parcel_number
      ])
  end
end
