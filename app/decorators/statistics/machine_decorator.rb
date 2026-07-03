class Statistics::MachineDecorator < Draper::Decorator
  delegate_all

  def hours(term)
    value = context[:hours][[term, object.id]]
    return "" if value.blank? || value.zero?

    h.number_to_currency(value, precision: 1, unit: "")
  end
end
