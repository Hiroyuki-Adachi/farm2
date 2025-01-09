class UserMailer < ApplicationMailer
  def email_confirmation(user)
    @user = user
    mail(to: @user.mail, subject: 'メールアドレス認証')
  end

  def ip_confirmation(ip)
    @ip = ip
    @token = ip.token
    mail(to: @ip.created_user.mail, subject: 'IPアドレス認証')
  end
end
