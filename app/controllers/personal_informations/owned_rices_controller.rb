class PersonalInformations::OwnedRicesController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @owned_rices = OwnedRice.by_home(current_term, @worker.home.id).available
  end
end
