require 'wareki'

class WorkVerificationDecorator < Draper::Decorator
  delegate_all

  def short_name
    WorkerDecorator.decorate(model.worker).short_name
  end

  def updated_at
    model.updated_at.to_date.strftime('%Je')[0] + model.updated_at.to_date.strftime('%Jg-%m-%d')
  end
end
