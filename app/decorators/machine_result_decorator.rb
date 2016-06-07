class MachineResultDecorator < Draper::Decorator
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
  def worked_at
    return model.work.worked_at.strftime('%Y-%m-%d') + "(#{WDAY[model.work.worked_at.wday]})"
  end

  def work_type_name
    return model.work.work_type.genre_name + "(#{model.work.work_type.name})"
  end
  
  def work_name
    return model.work.name.present? ? (model.work.work_kind.other_flag ? model.work.name : model.work.work_kind.name + "(#{model.work.name})") : model.work.work_kind.name
  end

  def price
    return h.number_to_currency(model.price, {precision: 0, unit: ""})
  end

  def quantity
    return case model.adjust
      when Adjust::HOUR
        h.number_to_currency(model.quantity, {precision: 1, unit: ""})
      when Adjust::DAY
        h.number_to_currency(model.quantity, {precision: 0, unit: ""})
      when Adjust::AREA
        h.number_to_currency(model.quantity, {precision: 3, unit: ""})
    end
  end

  def amount
    return h.number_to_currency(model.amount, {precision: 0, unit: ""})
  end
end
