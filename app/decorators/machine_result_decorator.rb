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
    "#{model.work.work_type&.category_name}(#{model.work.work_type&.name})"
  end

  def work_name
    if model.work.name.present?
      model.work.work_kind.other_flag ? model.work.name : model.work.work_kind.name + "(#{model.work.name})"
    else
      model.work.work_kind.name
    end
  end

  def price
    h.number_to_currency(model.price, { precision: 0, unit: "" })
  end

  def quantity
    case model.adjust
    when Adjust::HOUR
      h.number_to_currency(model.quantity, { precision: hour_quantity_precision, unit: "" })
    when Adjust::DAY
      h.number_to_currency(model.quantity, { precision: 0, unit: "" })
    when Adjust::AREA
      h.number_to_currency(model.quantity, { precision: 3, unit: "" })
    end
  end

  def type_name
    model.machine.type_name
  end

  def amount
    h.number_to_currency(model.amount, { precision: 0, unit: "" })
  end

  def unit
    model.adjust.unit
  end

  private

  # 0.5時間刻みのデータは小数1位、#1119期間中に登録された0.25時間刻みの
  # 既存データは小数2位まで表示し、丸めによる誤表示を避ける。
  def hour_quantity_precision
    ((model.quantity * 2) % 1).zero? ? 1 : 2
  end
end
