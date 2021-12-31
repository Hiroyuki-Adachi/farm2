class ChemicalStockDecorator < Draper::Decorator
  delegate_all

  def long_name
    model.chemical_inventory_id ? "#{model.chemical_inventory.chemical_adjust_type.name}(#{model.name})" : model.name
  end

  def stored_format
    model.stored ? h.number_to_currency(model.stored, precision: 1, format: "%n%u", unit: model.chemical.stock_unit) : ""
  end

  def shipping_format
    (model.shipping || model.using) ?
    h.number_to_currency((model.shipping || model.using), precision: 1, format: "%n%u", unit: model.chemical.stock_unit) : ""
  end

  def stock_format
    h.number_to_currency(model.stock, precision: 1, format: "%n%u", unit: model.chemical.stock_unit)
  end

  def adjust_format
    h.number_to_currency(model.adjust, precision: 1, format: "+%n%u", negative_format: "-%n%u", unit: model.chemical.stock_unit)
  end

  def tr_class
    if model.chemical_inventory_id.present? && model.chemical_inventory.inventory?
      "table-warning"
    elsif model.chemical_inventory_id.present? && model.chemical_inventory.stored?
      "table-primary"
    elsif model.work_chemical_id.present?
      "table-danger"
    else
      ""
    end
  end
end
