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

  def creator_name
    object.creator&.name || "（未設定）"
  end

  def assignee_name
    object.assignee&.name || "（未設定）"
  end

  def due_on_display
    return "（未設定）" if object.due_on.blank?

    I18n.l(object.due_on, format: :long)
  end

  def office_role_name
    I18n.t("activerecord.attributes.task.office_roles.#{object.office_role}")
  end

  def end_reason_name
    return "" if object.end_reason_unset?

    I18n.t("activerecord.attributes.task.end_reasons.#{object.end_reason}")
  end
end
