class MachineResultDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
  def worked_at
    model.work.worked_at.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.work.worked_at.wday]})"
  end

  def worked_at_short
    model.work.worked_at.strftime('%m/%d')
  end

  def work_type_name
    model.work.work_type.genre_name + "(#{model.work.work_type.name})"
  end

  def work_name
    if model.work.name.present?
      model.work.work_kind.other_flag ? model.work.name : model.work.work_kind.name + "(#{model.work.name})"
    else
      model.work.work_kind.name
    end
  end

  def price
    h.number_to_currency(model.price, {precision: 0, unit: ""})
  end

  def quantity
    case model.adjust
    when :hour
      h.number_to_currency(model.quantity, {precision: 1, unit: ""})
    when :day
      h.number_to_currency(model.quantity, {precision: 0, unit: ""})
    when :area
      h.number_to_currency(model.quantity, {precision: 3, unit: ""})
    end
  end

  def type_name
    model.machine.type_name
  end

  def amount
    h.number_to_currency(model.amount, {precision: 0, unit: ""})
  end

  def unit
    I18n.t("activerecord.enums.adjust.units.#{model.adjust}")
  end
end
