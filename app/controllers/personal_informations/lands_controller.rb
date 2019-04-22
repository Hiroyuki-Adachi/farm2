class PersonalInformations::LandsController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @lands = WorkLand.for_personal(@worker.home, now_system.start_date)
    @land_costs = LandCost.newest(Time.zone.today).where(land_id: @lands.map(&:land_id))
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
  end
end
