class WorkDecorator < Draper::Decorator
  delegate_all

  WDAY = ["日", "月", "火", "水", "木", "金", "土"]

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def self.months(term)
    months = []
    months << ["全て", ""]
    Work.months(term).each {|w|
      worked_month = DateTime.parse(w.worked_month.to_s)
      months << [worked_month.strftime("%Y年%m月"), worked_month.strftime("%Y-%m-01")]
    }
    return months
  end

  def worked_at
    return model.worked_at.strftime('%Y-%m-%d') + "(#{WDAY[model.worked_at.wday]})"
  end

  def fixed_at
    return model.fixed_at.strftime('%Y年 %m月') if model.fixed_at
  end

  def name
    return model.name.present? ? (model.work_kind.other_flag ? model.name : model.work_kind.name + "(#{model.name})") : model.work_kind.name
  end

  def work_time
    return self.start_at + '～' + self.end_at
  end

  def start_at
    return model.start_at.strftime("%H:%M")
  end

  def end_at
    return model.end_at.strftime("%H:%M")
  end

  def chemicals
    result = []
    model.work_chemicals.each do |work_chemical|
      result << work_chemical.chemical.name + "(" + work_chemical.chemical.chemical_type.name + "):" + work_chemical.quantity.to_s
    end
    return result.join(", ")
  end
  
  def genre_name
    return model.work_type.genre_name + "(#{model.work_type.name})"
  end
  
  def select_work_type(work_type)
    return h.raw((work_type.id == model.work_type_id ? "●" : "&nbsp;") + work_type.name)
  end
  
  def weather_name
    return model.weather.name
  end
end
