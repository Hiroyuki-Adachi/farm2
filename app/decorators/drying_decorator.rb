class DryingDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def work_type_name
    model.work_type&.name
  end

  def carried_on
    model.carried_on&.strftime('%m月%d日')
  end

  def shipped_on
    model.shipped_on&.strftime('%m月%d日')
  end

  def water_content
    model.water_content&.positive? ? format("%.1f", model.water_content) : ""
  end

  def dry_rice_weight
    model.rice_weight&.positive? ? model.rice_weight.to_s(:delimited) : ""
  end

  def adjust_rice_weight
    model.adjustment&.rice_weight&.positive? ? model.adjustment.rice_weight.to_s(:delimited) : ""
  end
end
