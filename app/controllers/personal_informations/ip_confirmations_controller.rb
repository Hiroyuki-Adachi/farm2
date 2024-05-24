class PersonalInformations::IpConfirmationsController < PersonalInformationsController
  def edit
    IpList.confirm!(current_user, params[:ip_token])
    head :ok
  end
end
