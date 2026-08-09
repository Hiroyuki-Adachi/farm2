class PersonalInformations::MailAddressesController < PersonalInformationsController
  helper MailHelper

  def new; end

  def create
    if current_user.update(mail_address_params)
      if current_user.mail.present?
        UserMailer.email_confirmation(current_user).deliver_later
        redirect_to personal_information_path(token: current_user.token),
                    notice: 'メールを送信しました。メール内のリンクをクリックしてメールアドレスの変更を完了してください'
      else
        redirect_to personal_information_path(token: current_user.token), notice: 'メールアドレスを削除しました'
      end
    else
      flash.now[:alert] = 'メールアドレスの変更に失敗しました'
      render :new, status: :unprocessable_content
    end
  end

  private

  def mail_address_params
    params.expect(user: [:mail])
  end
end
