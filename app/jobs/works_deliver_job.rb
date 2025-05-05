class WorksDeliverJob < ApplicationJob
  queue_as :default

  def perform
    User.linable.each do |user|
      next unless Work.deliverable(user.worker).exists?

      messages = ['日報データが登録されています。']
      messages << "#{Rails.application.routes.url_helpers.personal_information_url(token: user.token)}"
      LineHookService.push_message(user.line_id, messages.join("\n"))
    end
  end
end
