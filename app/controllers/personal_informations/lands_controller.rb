class PersonalInformations::LandsController < PersonalInformationsController
  def index
    @lands = LandDecorator.decorate_collection(Land.for_organization(current_organization).usual.expiry.for_personal(@worker.home))
  end

  def show
    @land = Land.for_organization(current_organization).find(params[:id]).decorate
    @work_lands = WorkLandDecorator.decorate_collection(WorkLand.for_cards(@land.id, now_system.start_date))
    @land_costs = LandCostDecorator.decorate_collection(LandCost.by_land(@land.id))
  end
end
