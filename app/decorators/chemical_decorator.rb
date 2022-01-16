class ChemicalDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def this_term_flag(term)
    model.this_term?(term) ? "●" : ""
  end

  def stock_name
    "#{model.name}(#{model.stock_base_quantity}#{model.stock_unit_name})"
  end

  def stored_name
    "#{model.name}(#{model.carton_base_quantity}#{model.carton_unit_name})"
  end
end
