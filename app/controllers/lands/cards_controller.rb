class Lands::CardsController < ApplicationController
  include PermitChecker

  helper GmapHelper

  def index
    @costs = LandCost.usual(Land.for_organization(current_organization).regionable.expiry(Time.zone.today), Time.zone.today).includes(land: :owner).includes(:work_type)
  end

  def show
    @land = Land.for_organization(current_organization).find(params[:land_id])
    # 前期の期首から表示する。前期がなければ当期の期首から。
    start_date = (now_system.previous_system || now_system).start_date
    @work_lands = WorkLandDecorator.decorate_collection(WorkLand.for_cards(@land.id, start_date))
  end
end
