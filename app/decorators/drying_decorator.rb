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

  def carried_on_short
    model.carried_on&.strftime('%m-%d')
  end

  def shipped_on
    model.shipped_on&.strftime('%m月%d日')
  end

  def shipped_on_short
    model.shipped_on&.strftime('%m-%d')
  end

  def water_content
    model.water_content&.positive? ? format("%.1f", model.water_content) : ""
  end

  def dry_rice_weight
    model.rice_weight&.positive? ? model.rice_weight.to_s(:delimited) : ""
  end

  def all_rice_weight
    return model.rice_weight || 0 unless model.drying_type == DryingType::SELF
    model&.adjustment&.rice_weight || 0
  end

  def all_rice_weight_format
    all_rice_weight.to_s(:delimited)
  end

  def all_rice_bag
    return model.rice_bag unless model.drying_type == DryingType::SELF
    (model&.adjustment&.rice_weight || 0) / Drying::KG_PER_BAG
  end

  def all_rice_bag_format
    format("%.2f", all_rice_bag)
  end

  def adjust_rice_bag
    model.adjustment&.rice_bag&.positive? ? model.adjustment.rice_bag : ""
  end

  def adjust_half_weight
    model.adjustment&.half_weight&.positive? ? format("%.1f", model.adjustment.half_weight) : ""
  end

  def adjust_waste_weight
    model.adjustment&.waste_weight&.positive? ? format("%.1f", model.adjustment.waste_weight) : ""
  end

  def drying_type_name(home_id)
    return DryingType::ADJUST.name if model.adjust_only?(home_id)
    return model.drying_type.name
  end
end
