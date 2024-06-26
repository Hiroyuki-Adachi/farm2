require 'date'

class ScheduleWorkerDecorator < Draper::Decorator
  delegate_all
  decorates_association :schedule

  def worked_at
    result = case model.schedule.worked_at - Time.zone.today
             when 0
               "今日"
             when 1
               "明日"
             when 2
               "明後日"
             when 7
               "一週間後"
             else
               "#{(model.schedule.worked_at - Time.zone.today).to_i}日後"
             end
    result += "(#{model.schedule.worked_at.strftime('%m月%d日')})(#{I18n.t('date.abbr_day_names')[model.schedule.worked_at.wday]})"
    result += " #{schedule.start_at_jp}"
    return result
  end

  def name
    "#{schedule.work_type.name}(#{schedule_name})"
  end

  delegate :name, to: :schedule, prefix: true
end
