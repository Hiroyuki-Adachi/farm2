module DryingsHelper
  def format_weight(weight)
    weight.to_s(:delimited)
  end

  def format_bag(weight)
    format("%.2f", weight / Drying::KG_PER_BAG)
  end

  def format_rice_percentage(rice_weight, waste_weight)
    return "" if (rice_weight + waste_weight).zero?
    return format("%.2f", waste_weight / (rice_weight + waste_weight) * 100)
  end

  def calc_amount(weight, price)
    weight / Drying::KG_PER_BAG * price
  end

  def format_amount(weight, price)
    number_to_currency(calc_amount(weight, price), {precision: 0, unit: ""})
  end
end
