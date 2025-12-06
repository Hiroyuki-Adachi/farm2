class ScheduleDeliverJob < ApplicationJob
  queue_as :default

  def perform(timing)
    raise ArgumentError, "Missing timing argument" if timing.blank?

    User.linable.each do |user|
      messages, schedules = case timing.to_sym
                            when :morning
                              [
                                [I18n.t('line_deliver_schedule.morning')],
                                ScheduleDecorator.decorate_collection(Schedule.by_worker(user.worker).today.linable.pm_only)
                              ]
                            when :afternoon
                              [
                                [I18n.t('line_deliver_schedule.afternoon')],
                                ScheduleDecorator.decorate_collection(Schedule.by_worker(user.worker).tomorrow.linable.am_only)
                              ]
                            else
                              raise ArgumentError, "Unknown timing: #{timing.inspect}"
                            end
      next if schedules.blank?

      schedules.each do |schedule|
        messages << "#{schedule.start_at}から#{schedule.name}です。"
      end

      LineHookService.push_message(user.line_id, messages.join("\n"), retry_key: SecureRandom.uuid)
    end
  end
end
