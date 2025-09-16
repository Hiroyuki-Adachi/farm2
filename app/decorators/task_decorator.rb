class TaskDecorator < Draper::Decorator
  delegate_all

  def priority_color
    I18n.t("activerecord.attributes.task.priority_colors.#{object.priority}")
  end

  def priority_name
    I18n.t("activerecord.attributes.task.priorities.#{object.priority}")
  end

  def priority_badge
    h.content_tag(:span, priority_name, class: "badge text-bg-#{priority_color}")
  end

  def status_name
    object.task_status.name
  end

  def status_badge
    h.content_tag(:span, status_name, class: object.task_status.badge_class)
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

  def started_on_display
    return "（未設定）" if object.started_on.blank?

    I18n.l(object.started_on, format: :long)
  end

  def ended_on_display
    return "（未設定）" if object.ended_on.blank?

    I18n.l(object.ended_on, format: :long)
  end

  def due_status
    return :unset   if due_on.blank?
    return :expired if due_on < Date.current
    return :today   if due_on == Date.current
    return :soon    if due_on <= Date.current + 3
    :ok
  end

  def due_badge
    case due_status
    when :expired then h.content_tag(:span, "期限切れ", class: "badge bg-danger")
    when :today   then h.content_tag(:span, "今日が期限", class: "badge bg-warning text-dark")
    when :soon    then h.content_tag(:span, "期限が近い", class: "badge bg-primary")
    else ""      
    end
  end

  def office_role_name
    I18n.t("activerecord.attributes.task.office_roles.#{object.office_role}")
  end

  def end_reason_name
    return "" if object.end_reason_unset?

    I18n.t("activerecord.attributes.task.end_reasons.#{object.end_reason}")
  end
end
