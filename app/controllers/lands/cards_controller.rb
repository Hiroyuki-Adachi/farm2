class Lands::CardsController < ApplicationController
  include PermitChecker

  helper GmapHelper

  def index
    @costs = LandCost.usual(Land.for_organization(current_organization).regionable.expiry(Time.zone.today), Time.zone.today).includes(land: :owner).includes(:work_type)
  end

  def show
    @land = Land.for_organization(current_organization).find(params[:land_id])
    @work_lands = WorkLandDecorator.decorate_collection(WorkLand.for_cards(params[:land_id], now_system.start_date.prev_year))
  end
end
