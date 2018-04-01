class WorkerDecorator < Draper::Decorator
  delegate_all

  def short_name
    model.family_name[0, 2] + "(" + model.first_name[0] + ")"
  end
end
