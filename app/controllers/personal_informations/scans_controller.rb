class PersonalInformations::ScansController < PersonalInformationsController
  before_action :decode_params, only: [:create]

  def index; end

  def create
  end

  private

  def decode_params
    
  end
end
