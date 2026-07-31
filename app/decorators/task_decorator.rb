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
    return "" unless object.created_at >= new_days.days.ago

    render_badge("新規", "badge bg-info")
  end

  def status_badge
    super(object.status)
  end

  def end_badge
    return "" unless object.closed?

    case object.end_reason.to_sym
    when :no_action
      render_badge("不要", "badge bg-danger")
    when :unavailable
      render_badge("無効", "badge text-bg-warning")
    when :duplicated
      render_badge("重複", "badge bg-secondary")
    else
      ""
    end
  end

  def creator_name
    return object.creator.name if object.creator.present?
    return kind_badge if object.template.present?

    "（未設定）"
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
      render_badge(kind_name, "badge text-bg-warning")
    else
      case object.template.kind.to_sym
      when :annual
        render_badge(kind_name, "badge text-bg-info")
      when :monthly
        render_badge(kind_name, "badge text-bg-success")
      when :any_time
        render_badge(kind_name, "badge text-bg-secondary")
      else
        render_badge("（未設定）", "badge text-bg-light")
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

  def highlight?
    return false if object.assignee_id != context[:current_worker]&.id
    return true if object.high? || object.urgent?
    return true if [:expired, :today, :soon].include?(due_status)

    false
  end

  def text_display
    fw = highlight? ? 'highlight' : 'normal'
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
    when :expired then render_badge("期限切れ", "badge bg-danger")
    when :today   then render_badge("今日が期限", "badge bg-warning text-dark")
    when :soon    then render_badge("期限が近い", "badge bg-primary")
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
    return "" unless object.watching?

    render_badge("●", "text-danger", title: "監視中")
  end

  def unread_count_badge
    return "" if object.unread_count.to_i.zero?

    render_badge(object.unread_count, "badge bg-primary rounded-pill")
  end

  def assignee_badge
    if object.assignee_id == context[:current_worker]&.id
      render_badge("あなた", "badge bg-danger text-white")
    else
      render_badge(assignee_name, "badge bg-secondary")
    end
  end

  private

  def render_badge(text, css_class, **html_options)
    h.render(Tasks::BadgeComponent.new(text: text, css_class: css_class, **html_options))
  end
end
