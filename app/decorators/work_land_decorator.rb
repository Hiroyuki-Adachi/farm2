class WorkLandDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def area
    return format("%.2f", model.land.area)
  end

  def place
    return model.land.place
  end

  def place_name
    return model.land.place + "(#{model.land.owner.name})"
  end

  def worked_at_short
    model.work.worked_at.strftime('%m/%d')
  end

  def work_kind_name
    model.work.work_kind.name
  end
end
