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
    model.fixed_at ? model.fixed_at.strftime("%Y年 %m月") : nil
  end

  def fixer_short_name
    model.fixer ? WorkerDecorator.decorate(model.fixer).short_name : nil
  end

  def hours
    h.number_to_currency(model.hours, {precision: 1, unit: ""})
  end

  def works_amount
    h.number_to_currency(model.works_amount, {precision: 0, unit: ""})
  end

  def machines_amount
    h.number_to_currency(model.machines_amount, {precision: 0, unit: ""})
  end
end
