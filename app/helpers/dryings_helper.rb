module DryingsHelper
  def format_weight(weight)
    weight.to_formatted_s(:delimited)
  end

  def format_bag(weight)
    format("%.1f", ((weight || 0) / Drying::KG_PER_BAG_RICE).floor(1))
  end

  def format_waste_bag(weight)
    format("%.1f", ((weight || 0) / Drying::KG_PER_BAG_WASTE).floor(1))
  end

  def format_rice_percentage(rice_weight, waste_weight)
    return "" if ((rice_weight || 0) + (waste_weight || 0)).zero?
    return format("%.2f", (waste_weight || 0) / ((rice_weight || 0) + (waste_weight || 0)) * 100)
  end

  def calc_amount(weight, price)
    (((weight || 0) / Drying::KG_PER_BAG_RICE).floor(1) * price).round(-2)
  end

  def calc_waste_amount(weight, price)
    (((weight || 0) / Drying::KG_PER_BAG_WASTE).floor(1) * price).round(-2)
  end

  def format_amount(weight, price)
    number_to_currency(calc_amount(weight, price), {precision: 0, unit: ""})
  end

  def format_waste_amount(weight, price)
    number_to_currency(calc_waste_amount(weight, price), {precision: 0, unit: ""})
  end

  def format_area(area)
    area ? format("%.1f", area) : ""
  end

  def format_rolls(rolls)
    format("%.1f", rolls)
  end
end
