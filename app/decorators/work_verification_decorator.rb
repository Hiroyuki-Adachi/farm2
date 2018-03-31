class WorkVerificationDecorator < Draper::Decorator
  delegate_all

  def short_name
    WorkerDecorator.decorate(model.worker).short_name
  end

  def updated_at
    model.updated_at.strftime('%Y-%m-%d')
  end
end
