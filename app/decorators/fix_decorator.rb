class FixDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def fixed_at
    return model.fixed_at.strftime("%Y年 %m月")
  end

  def hours
    return h.number_to_currency(model.hours, {precision: 1, unit: ""})
  end

  def works_amount
    return h.number_to_currency(model.works_amount, {precision: 0, unit: ""})
  end

  def machines_amount
    return h.number_to_currency(model.machines_amount, {precision: 0, unit: ""})
  end
end
