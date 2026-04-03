class ScheduleDeliverJob < ApplicationJob
  queue_as :default

  include Rails.application.routes.url_helpers

  def perform(timing)
    raise ArgumentError, "Missing timing argument" if timing.blank?

    timing = timing.to_sym
    raise ArgumentError, "Unknown timing: #{timing.inspect}" unless %i[morning afternoon].include?(timing)

    User.linable.includes(:worker).find_each do |user|
      deliver_line_notification(user, timing)
    end

    User.web_push_notifiable.includes(:worker, :web_push_subscriptions).find_each do |user|
      deliver_web_push_notification(user, timing)
    end
  end

  private

  def deliver_line_notification(user, timing)
    header, schedules = delivery_payload_for(user, timing)
    return if schedules.blank?

    messages = [header]
    schedules.each do |schedule|
      messages << "#{schedule.start_at}から#{schedule.name}です。"
    end

    LineHookService.push_message(user.line_id, messages.join("\n"), retry_key: SecureRandom.uuid)
  end

  def deliver_web_push_notification(user, timing)
    return unless WebPushService.configured?

    header, schedules = delivery_payload_for(user, timing)
    return if schedules.blank?

    payload = {
      title: I18n.t('push_notification.schedule.title'),
      body: ([header] + schedules.map { |schedule| "#{schedule.start_at}から#{schedule.name}です。" }).join("\n"),
      tag: "schedule-#{timing}-#{target_date_for(timing)}-user-#{user.id}",
      url: personal_information_schedules_path(personal_information_token: user.token)
    }

    user.web_push_subscriptions.each do |subscription|
      WebPushService.push(subscription, payload)
    end
  end

  def delivery_payload_for(user, timing)
    case timing
    when :morning
      [
        I18n.t('line_deliver_schedule.morning'),
        ScheduleDecorator.decorate_collection(Schedule.for_delivery(user.worker).today.linable.pm_only)
      ]
    when :afternoon
      [
        I18n.t('line_deliver_schedule.afternoon'),
        ScheduleDecorator.decorate_collection(Schedule.for_delivery(user.worker).tomorrow.linable.am_only)
      ]
    end
  end

  def target_date_for(timing)
    timing == :morning ? Time.zone.today : Date.tomorrow
  end
end
