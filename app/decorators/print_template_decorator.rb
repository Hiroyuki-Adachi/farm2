class PrintTemplateDecorator < Draper::Decorator
  delegate_all

  def paper_size_name
    I18n.t("activerecord.enums.print_template.paper_sizes.#{object.paper_size}")
  end

  def sides_name
    I18n.t("activerecord.enums.print_template.sides.#{object.sides}")
  end

  def row_class
    object.active? ? "" : "table-warning"
  end
end
