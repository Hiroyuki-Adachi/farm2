class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail(to: @user.mail, subject: 'メールアドレス認証')
  end
end
