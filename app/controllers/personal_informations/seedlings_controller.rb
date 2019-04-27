class PersonalInformations::SeedlingsController < PersonalInformationsController
  def index
    @seedling_homes = SeedlingHome.usual(@current_user.term).by_home(@worker.home)
  end
end
