class LandCostsController < ApplicationController
  include PermitManager

  before_action :set_work_types, only: [:index]
  before_action :set_land_cost, only: [:index]
  before_action :clear_session

  def index
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
    redirect_to land_costs_path(land_place_id: params[:land_place_id]) unless params[:land_costs]
    LandCost.transaction do
      params[:land_costs].each do |_, land_cost|
        if land_cost[:id].present?
          @land_cost = LandCost.find(land_cost[:id])
          session[:land_cost] = @land_cost.attributes unless @land_cost.update(land_cost_params(land_cost))
        else
          @land_cost = LandCost.new(land_cost_params(land_cost))
          session[:land_cost] = @land_cost.attributes unless @land_cost.save
        end
      end
    end
    redirect_to land_costs_path(land_place_id: params[:land_place_id])
  end

  private

  def set_work_types
    @work_types = WorkType.land
  end

  def set_land_cost
    @land_cost = session[:land_cost] ? LandCost.new(session[:land_cost]) : nil
    @land_cost.valid? if @land_cost
  end

  def land_cost_params(params)
    params.permit(:work_type_id, :cost, :land_id, :term)
  end

  def clear_session
    session[:land_cost] = nil
  end
end
