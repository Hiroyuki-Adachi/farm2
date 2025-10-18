class ScheduleDecorator < Draper::Decorator
  delegate_all
  decorates_association :workers

  TIMES = {
    "00:00" => "深夜０時", "00:30" => "深夜０時半", "01:00" => "深夜１時", "01:30" => "深夜１時半",
    "02:00" => "深夜２時", "02:30" => "深夜２時半", "03:00" => "深夜３時", "03:30" => "深夜３時半",
    "04:00" => "早朝４時", "04:30" => "早朝４時半", "05:00" => "早朝５時", "05:30" => "早朝５時半",
    "06:00" => "午前６時", "06:30" => "午前６時半", "07:00" => "午前７時", "07:30" => "午前７時半",
    "08:00" => "午前８時", "08:30" => "午前８時半", "09:00" => "午前９時", "09:30" => "午前９時半",
    "10:00" => "午前10時", "10:30" => "午前10時半", "11:00" => "午前11時", "11:30" => "午前11時半",
    "12:00" => "正午", "12:30" => "12時半", "13:00" => "午後１時", "13:30" => "午後１時半",
    "14:00" => "午後２時", "14:30" => "午後２時半", "15:00" => "午後３時", "15:30" => "午後３時半",
    "16:00" => "午後４時", "16:30" => "午後４時半", "17:00" => "午後５時", "17:30" => "午後５時半",
    "18:00" => "午後６時", "18:30" => "午後６時半", "19:00" => "午後７時", "19:30" => "午後７時半",
    "20:00" => "午後８時", "20:30" => "午後８時半", "21:00" => "午後９時", "21:30" => "午後９時半",
    "22:00" => "午後10時", "22:30" => "午後10時半", "23:00" => "深夜11時", "23:30" => "深夜11時半"
  }.freeze

  def worked_at
    model.worked_at.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.worked_at.wday]})"
  end

  def category_name
    "#{model.work_type&.category_name}(#{model.work_type&.name})"
  end

  def name
    if model.name.present?
      model.work_kind.other_flag ? model.name : model.work_kind.name + "(#{model.name})"
    else
      model.work_kind.name
    end
  end

  def worker_names
    results = workers.map(&:name)
    return results.to_sentence
  end

  def work_flag
    return model.work_flag ? "作業" : "作業以外"
  end

  def work_time
    "#{start_at}～#{end_at}"
  end

  def start_at
    model.start_at.strftime("%H:%M")
  end

  def start_at_jp
    TIMES.fetch(model.start_at.strftime("%H:%M"), model.start_at.strftime("%H:%M"))
  end

  def end_at
    model.end_at.strftime("%H:%M")
  end

  def line_flag
    model.line_flag ? "◯" : ""
  end

  def minutes_flag
    model.minutes_flag ? "◯" : ""
  end
end
