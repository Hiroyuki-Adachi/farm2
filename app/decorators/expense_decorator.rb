class ExpenseDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def payed_on
    model.payed_on.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.payed_on.wday]})"
  end

  def amount
    h.number_to_currency(model.amount, {precision: 0, unit: ""})
  end

  def discount_amount
    h.number_to_currency(model.discount_amount, {precision: 0, unit: ""})
  end

  def work_types
    model.expense_work_types.includes(:work_type).reject{ |ewt| ewt.rate.zero?}.map{ |ewt| ewt.work_type_name}&.join(",")
  end

  def content
    model.chemical? ? model.chemical.name : model.content
  end

  def cost_flag
    model.cost_flag ? "支払時" : "使用時"
  end
end
