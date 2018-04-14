class WorkBroccoliDecorator < Draper::Decorator
  delegate_all

  def shipped_on
    model.shipped_on.strftime('%Y-%m-%d') if model.shipped_on
  end

  def box_name
    model.box ? model.box.display_name : ""
  end
end
