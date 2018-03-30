class WorkVerificationDecorator < Draper::Decorator
  delegate_all

  def short_name
    model.worker.family_name + "(" + model.worker.first_name[0] + ")"
  end

  def updated_at
    model.updated_at.strftime('%Y-%m-%d')
  end
end
