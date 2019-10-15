class PersonalInformations::DryingsController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @dryings = DryingDecorator.decorate_collection(Drying.by_home(@current_user.term, @worker.home))
    @total_dryings, @waste_totals = Drying.calc_total(@dryings, @worker.home, current_system)
  end
end
