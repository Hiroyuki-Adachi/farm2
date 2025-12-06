class WorksDeliverJob < ApplicationJob
  queue_as :default

  def perform
    User.linable.each do |user|
      next unless Work.deliverable(user.worker).exists?

      messages = ['昨日、新しい日報データが入力されています。']
      messages << Rails.application.routes.url_helpers.personal_information_url(token: user.token).to_s
      LineHookService.push_message(user.line_id, messages.join("\n"), retry_key: SecureRandom.uuid)
    end
  end
end
