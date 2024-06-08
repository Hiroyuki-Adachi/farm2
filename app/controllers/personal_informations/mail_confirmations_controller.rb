class PersonalInformations::MailConfirmationsController < PersonalInformationsController
  def edit
    current_user.mail_confirm!(params[:mail_token])
    head :ok
  end
end
