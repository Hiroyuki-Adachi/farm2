class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail(to: @user.mail, subject: 'メールアドレス認証')
  end

  def ip_confirmation(ip, token)
    @ip = ip
    @token = token
    mail(to: @ip.created_user.mail, subject: 'IPアドレス認証')
  end
end
