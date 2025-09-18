class TaskEventDecorator < Draper::Decorator
  include TaskStatusPresenter
  
  delegate_all
  decorates_association :actor
  decorates_association :assignee_from
  decorates_association :assignee_to

  def status_from_badge
    return '（未設定）' if object.status_from.nil?
    status_badge(object.status_from)
  end

  def status_to_badge
    return '（未設定）' if object.status_to.nil?
    status_badge(object.status_to)
  end

  def created_at_display
    h.l(object.created_at, format: :short)
  end

  def actor_name
    object.actor&.name || '（不明）'
  end

  def assignee_from_name
    object.assignee_from&.name || '(未担当)'
  end

  def assignee_to_name
    object.assignee_to&.name || '(未担当)'
  end

  def assignee_from_badge
    if object.assignee_from_id == context[:current_worker]&.id
      h.content_tag(:span, "あなた", class: 'badge bg-danger text-white')
    else
      h.content_tag(:span, "#{assignee_from_name}", class: 'badge bg-secondary') + "さん"
    end
  end

  def assignee_to_badge
    if object.assignee_to_id == context[:current_worker]&.id
      h.content_tag(:span, "あなた", class: 'badge bg-danger text-white')
    else
      h.content_tag(:span, "#{assignee_to_name}", class: 'badge bg-secondary') + "さん"
    end
  end

  def due_on_from_display
    return "（未設定）" if object.due_on_from.blank? 

    h.l(object.due_on_from, format: :short)
  end

  def due_on_to_display
    return "（未設定）" if object.due_on_to.blank?

    h.l(object.due_on_to, format: :short)
  end

  def human_message
    case object.event_type.to_sym
    when :task_created
      'タスクが作成されました。'
    when :change_status
      "ステータスが #{status_to_badge} に変更されました。"
    when :change_assignee
      "担当者が #{assignee_to_badge} に変更されました。"
    when :change_due_on
      "期限が #{due_on_to_display} に変更されました。"
    else
      ""
    end
  end
end
