module DryingsHelper
  def format_weight(weight)
    weight.to_s(:delimited)
  end

  def format_bag(weight)
    format("%.2f", weight / Drying::KG_PER_BAG)
  end

  def format_amount(weight, price)
    number_to_currency(weight / Drying::KG_PER_BAG * price, {precision: 0, unit: ""})
  end
end
