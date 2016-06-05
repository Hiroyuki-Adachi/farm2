class WorkResultDecorator < Draper::Decorator
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
  
  def worker_name(organization)
    if organization.print_home?
      return model.worker.name + "(" + model.worker.home.name + ")"
    elsif organization.print_section?
      return model.worker.name + "(" + model.worker.home.section.name + ")"
    end
    return model.worker.name
  end
  
  def home_name
    return model.worker.home.name
  end
  
  def worked_at
    return model.work.worked_at.strftime('%Y-%m-%d') + "(#{WDAY[model.work.worked_at.wday]})"
  end
  
  def work_type_name
    return model.work.work_type.genre_name + "(#{model.work.work_type.name})"
  end
  
  def work_name
    return model.work.name.present? ? (model.work.work_kind.other_flag ? model.work.name : model.work.work_kind.name + "(#{model.work.name})") : model.work.work_kind.name
  end
  
  def hours
    return sprintf("%.1f", model.hours)
  end
  
  def price(term)
    return h.number_to_currency(model.work.work_kind.term_price(term), {precision: 0, unit: ""})
  end
end
