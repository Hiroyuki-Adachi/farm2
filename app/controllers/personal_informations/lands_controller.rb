class PersonalInformations::LandsController < PersonalInformationsController
  def index
    @lands = WorkLand.for_personal(@worker.home, current_term)
    @land_costs = LandCost.where(land_id: @lands.map(&:land_id))
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
  end

  def show
    @land = Land.find(params[:id]).decorate
    @work_lands = WorkLandDecorator.decorate_collection(WorkLand.for_cards(@land.id, now_system.start_date))
    @land_costs = LandCostDecorator.decorate_collection(LandCost.by_land(@land.id))
  end
end
