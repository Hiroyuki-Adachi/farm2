require 'date'

class ScheduleWorkerDecorator < Draper::Decorator
  delegate_all
  decorates_association :schedule

  def worked_at
    result = case model.schedule.worked_at - Date.today
              when 0
                "今日"
              when 1
                "明日"
              else
                (model.schedule.worked_at - Date.today).to_s + "日後"
              end
    result += "(#{model.schedule.worked_at.strftime('%m月%d日')})"
    result += " #{schedule.start_at}"
    return result
  end

  def name
    schedule.work_type.name + "(" + schedule.name + ")"
  end
end
