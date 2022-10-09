class WorkTypeDecorator < Draper::Decorator
  delegate_all

  def bg_color
    model.bg_color && model.land_flag ? model.bg_color : "transparent"
  end

  def fg_color
    model.bg_color && model.land_flag ? model.fg_color : "black"
  end
end
