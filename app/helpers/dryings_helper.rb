module DryingsHelper
  def format_weight(weight)
    weight.to_s(:delimited)
  end

  def format_bag(weight)
    format("%.2f", (weight || 0) / Drying::KG_PER_BAG_RICE)
  end

  def format_rice_percentage(rice_weight, waste_weight)
    return "" if ((rice_weight || 0) + (waste_weight || 0)).zero?
    return format("%.2f", (waste_weight || 0) / ((rice_weight || 0) + (waste_weight || 0)) * 100)
  end

  def calc_amount(weight, price)
    (weight || 0) / Drying::KG_PER_BAG_RICE * price
  end

  def format_amount(weight, price)
    number_to_currency(calc_amount(weight, price), {precision: 0, unit: ""})
  end

  def format_area(area)
    format("%.1f", area)
  end

  def format_rolls(rolls)
    format("%.1f", rolls)
  end
end
