class PersonalInformations::DryingsController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @dryings = DryingDecorator.decorate_collection(Drying.by_home(@current_user.term, @worker.home))
  end
end
