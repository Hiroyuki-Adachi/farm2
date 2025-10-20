class TaskDecorator < Draper::Decorator
  include PriorityPresenter
  include TaskStatusPresenter

  delegate_all
  decorates_association :creator
  decorates_association :assignee
  decorates_association :template

  SOON_DAYS = 3

  NEW_DAYS_USER = 1
  NEW_DAYS_SYSTEM = 3

  def priority_badge
    super(object.priority)
  end

  def new_badge
    new_days = object.creator_id.present? ? NEW_DAYS_USER : NEW_DAYS_SYSTEM
    if object.created_at >= new_days.days.ago
      h.content_tag(:span, "新規", class: "badge bg-info")
    else
      ""
    end
  end

  def status_badge
    super(object.status)
  end

  def creator_name
    return object.creator.name if object.creator.present?
    return kind_badge if object.template.present?
    return "（未設定）"
  end

  def assignee_name
    object.assignee&.name || "（未設定）"
  end

  def kind_name
    if object.template.blank?
      "臨時"
    else
      template.kind_name
    end
  end

  def kind_badge
    if object.template.blank?
      h.content_tag(:span, kind_name, class: "badge text-bg-warning")
    else
      case object.template.kind.to_sym
      when :annual
        h.content_tag(:span, kind_name, class: "badge text-bg-info")
      when :monthly
        h.content_tag(:span, kind_name, class: "badge text-bg-success")
      else
        ""
      end
    end
  end

  def due_on_display
    return "（未設定）" if object.due_on.blank?

    I18n.l(object.due_on, format: :long)
  end

  def due_on_short
    return "（未設定）" if object.due_on.blank?

    object.due_on.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[object.due_on.wday]})"
  end

  def started_on_display
    return "（未設定）" if object.started_on.blank?

    I18n.l(object.started_on, format: :long)
  end

  def started_on_short
    return "（未設定）" if object.started_on.blank?

    object.started_on.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[object.started_on.wday]})"
  end

  def ended_on_display
    return "（未設定）" if object.ended_on.blank?

    I18n.l(object.ended_on, format: :long)
  end

  def text_display
    fw = 'normal'
    fw = 'bold' if object.high? || object.urgent?
    fw = 'bold' if [:expired, :today, :soon].include?(due_status)

    h.content_tag(:span, object.title, class: "fw-#{fw}")
  end

  def due_status
    return :not_open unless object.open?
    return :unset   if due_on.blank?
    return :expired if due_on < Date.current
    return :today   if due_on == Date.current
    return :soon    if due_on <= Date.current + SOON_DAYS
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
    I18n.t("activerecord.enums.task.office_roles.#{object.office_role}")
  end

  def end_reason_name
    return "" if object.end_reason_unset?

    I18n.t("activerecord.enums.task.end_reasons.#{object.end_reason}")
  end

  def watching_name
    if object.watching?
      h.content_tag(:span, "●", class: "text-danger", title: "監視中")
    else
      ""
    end
  end

  def unread_count_badge
    return "" if object.unread_count.to_i.zero?

    h.content_tag(:span, object.unread_count, class: "badge bg-primary rounded-pill")
  end
end
