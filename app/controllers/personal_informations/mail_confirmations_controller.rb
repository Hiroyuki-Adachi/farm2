class PersonalInformations::MailConfirmationsController < PersonalInformationsController
  def edit
    if current_user.mail_confirm!(params[:mail_token])
      @message = "メールアドレスの確認が完了しました。"
    else
      @message = "メールアドレスの確認に失敗しました。"
    end
    render layout: false
  end
end
