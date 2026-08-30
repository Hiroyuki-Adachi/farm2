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

  def schedule_notification(user, header, schedules)
    @user = user
    @recipient_name = recipient_name(user)
    @header = header
    @schedules = schedules
    mail(to: @user.mail, subject: '作業予定のお知らせ')
  end

  def works_notification(user)
    @user = user
    @recipient_name = recipient_name(user)
    mail(to: @user.mail, subject: '日報登録のお知らせ')
  end

  def news_notification(user, user_topics)
    @user = user
    @recipient_name = recipient_name(user)
    @user_topics = user_topics
    mail(to: @user.mail, subject: 'ニュースのお知らせ')
  end

  private

  def recipient_name(user)
    user.worker&.name.presence || user.login_name
  end
end
