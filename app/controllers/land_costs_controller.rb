class LandCostsController < ApplicationController
  include PermitManager

  before_action :set_work_types, only: [:index, :edit]
  before_action :set_land_cost, only: [:index]
  before_action :set_land, only: [:edit, :update]
  before_action :clear_session

  helper GmapHelper

  def index
    @land_places = LandPlace.usual
    @land_place_id = (params[:land_place_id] || @land_places.first.id).to_i
    @lands = Land.where(land_place_id: @land_place_id).usual
    @costs = LandCost.usual(@lands, Time.zone.today)
    if request.xhr?
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html
      end
    end
  end

  def create
    redirect_to land_costs_path(land_place_id: params[:land_place_id]) unless params[:land_costs]
    LandCost.transaction do
      params[:land_costs].each do |_, land_cost|
        if land_cost[:id].present?
          @land_cost = LandCost.find(land_cost[:id])
          session[:land_cost] = @land_cost.attributes unless @land_cost.update_work_type(land_cost_params(land_cost), current_system.start_date)
        else
          @land_cost = LandCost.new(land_cost_params(land_cost))
          session[:land_cost] = @land_cost.attributes unless @land_cost.save
        end
      end
    end
    redirect_to land_costs_path(land_place_id: params[:land_place_id])
  end

  def edit
    @land.land_costs.build
  end

  def update
    if @land.update(land_params(params))
      redirect_to land_costs_path(land_place_id: @land.land_place)
    else
      render action: :edit
    end
  end

  def map
    @target = params[:target].present? ? params[:target] : Time.zone.today
    @costs = LandCost.usual(Land.regionable.expiry(@target), @target).includes(land: :owner).includes(:work_type)
    @work_types = WorkType.land.by_term(current_organization.get_term(@target))
  end

  private

  def set_work_types
    @work_types = WorkType.land.by_term(current_term)
  end

  def set_land
    @land = Land.find(params[:land_id])
  end

  def set_land_cost
    @land_cost = session[:land_cost] ? LandCost.new(session[:land_cost]) : nil
    @land_cost&.valid?
  end

  def land_cost_params(params)
    params.permit(:work_type_id, :land_id, :activated_on)
  end

  def land_params(params)
    params.require(:land).permit(land_costs_attributes: [:id, :activated_on, :work_type_id, :_destroy])
  end

  def clear_session
    session[:land_cost] = nil
  end
end
