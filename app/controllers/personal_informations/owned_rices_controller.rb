class PersonalInformations::OwnedRicesController < PersonalInformationsController
  def index
    @owned_rices = OwnedRice.by_home(current_term, @worker.home.id).available
  end
end
