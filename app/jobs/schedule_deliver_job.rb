class ScheduleDeliverJob < ApplicationJob
  queue_as :default

  def perform
    User.linable.each do |user|
      messages = ['明日は以下の予定です。']
      Schedule.by_worker(user.worker).tommorrow.each do |schedule|
        messages << "#{schedule.start_at.strftime('%H:%M')}から#{schedule.work_kind.name}です。"
      end

      LineHookService.push_message(user.line_id, messages.join("\n")) if messages.size > 1
    end
  end
end
