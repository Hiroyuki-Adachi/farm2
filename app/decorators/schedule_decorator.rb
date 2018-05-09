class ScheduleDecorator < Draper::Decorator
  delegate_all

  def worked_at
    model.worked_at.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.worked_at.wday]})"
  end

  def genre_name
    model.work_type.genre_name + "(#{model.work_type.name})"
  end

  def name
    if model.name.present?
      model.work_kind.other_flag ? model.name : model.work_kind.name + "(#{model.name})"
    else
      model.work_kind.name
    end
  end

  def worker_names
    results = []
    model.workers.each do |worker|
      results << WorkerDecorator.decorate(worker).short_name
    end
    return results.join(", ")
  end
end
