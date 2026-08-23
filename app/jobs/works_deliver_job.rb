class WorksDeliverJob < ApplicationJob
  queue_as :default

  def perform
    deliver_line_notifications
    deliver_mail_notifications
  end

  private

  def deliver_line_notifications
    User.linable.find_each do |user|
      next unless Work.deliverable(user.worker_id).exists?

      messages = ['昨日、新しい日報データが入力されています。']
      messages << Rails.application.routes.url_helpers.personal_information_url(token: user.token).to_s
      LineHookService.push_message(user.line_id, messages.join("\n"), retry_key: SecureRandom.uuid)
    end
  end

  def deliver_mail_notifications
    User.mail_notifiable.includes(:worker).find_each do |user|
      next unless Work.deliverable(user.worker_id).exists?

      UserMailer.works_notification(user).deliver_now
    end
  end
end
