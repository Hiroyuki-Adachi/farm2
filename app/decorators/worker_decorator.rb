class WorkerDecorator < Draper::Decorator
  delegate_all

  def short_name
    model.family_name + "(" + model.first_name[0] + ")"
  end

  def updated_at
    model.updated_at.strftime('%Y-%m-%d')
  end
end
