class TaskDecorator < Draper::Decorator
  delegate_all

  def priority_color
    I18n.t("activerecord.attributes.task.priority_colors.#{object.priority}")
  end

  def priority_name
    I18n.t("activerecord.attributes.task.priorities.#{object.priority}")
  end

  def status_color
    object.closed? ? "secondary" : "primary"
  end

  def status_name
    object.task_status.name
  end

  def end_reason_name
    return "" if object.end_reason_unset?

    I18n.t("activerecord.attributes.task.end_reasons.#{object.end_reason}")
  end
end
