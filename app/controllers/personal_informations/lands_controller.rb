class PersonalInformations::LandsController < PersonalInformationsController
  def index
    @lands = WorkLand.for_personal(@worker.home, current_term)
    @land_costs = LandCost.where(land_id: @lands.map(&:land_id))
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
  end
end
