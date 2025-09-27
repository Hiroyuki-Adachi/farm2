class TaskEventDecorator < Draper::Decorator
  include TaskStatusPresenter
  
  delegate_all
  decorates_association :actor
  decorates_association :assignee_from
  decorates_association :assignee_to
  decorates_association :work

  def status_from_badge
    return '（未設定）' if object.status_from.nil?
    status_badge(object.status_from)
  end

  def status_to_badge
    return '（未設定）' if object.status_to.nil?
    status_badge(object.status_to)
  end

  def created_at_display
    if object.created_at.to_date == Time.zone.today
      object.created_at.strftime('%H:%M')
    elsif object.created_at.to_date == Time.zone.yesterday
      "昨日 #{object.created_at.strftime('%H:%M')}"
    elsif object.created_at.year == Time.zone.today.year
      object.created_at.strftime('%m/%d %H:%M')
    else
      object.created_at.strftime('%Y/%m/%d %H:%M')
    end
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
      "#{h.content_tag(:span, assignee_from_name, class: 'badge bg-secondary')}さん"
    end
  end

  def assignee_to_badge
    if object.assignee_to_id == context[:current_worker]&.id
      h.content_tag(:span, "あなた", class: 'badge bg-danger text-white')
    else
      "#{h.content_tag(:span, assignee_to_name, class: 'badge bg-secondary')}さん"
    end
  end

  def due_on_from_display
    return "（未設定）" if object.due_on_from.blank? 

    h.l(object.due_on_from, format: :short)
  end

  def due_on_to_display
    return "（未設定）" if object.due_on_to.blank?

    if object.due_on_to == Time.zone.today
      "今日"
    elsif object.due_on_to == Time.zone.yesterday
      "昨日"
    elsif object.due_on_to == Time.zone.tomorrow
      "明日"
    elsif object.due_on_to == Time.zone.today + 2
      "明後日"
    elsif object.due_on_to.year == Time.zone.today.year
      object.due_on_to.strftime('%m/%d')
    else
      object.due_on_to.strftime('%Y/%m/%d')
    end
  end

  def human_message(mobile: false, mine: false)
    case object.event_type.to_sym
    when :task_created
      'タスクが作成されました。'
    when :change_status
      if object.work.present?
        "ステータスが #{status_to_badge} に変更されました。<br />#{work_message(mobile: mobile, mine: mine)}"
      else
        "ステータスが #{status_to_badge} に変更されました。"
      end
    when :change_assignee
      "担当者が #{assignee_to_badge} に変更されました。"
    when :change_due_on
      "期限が #{due_on_to_display} に変更されました。"
    when :add_work
      work_message(mobile: mobile, mine: mine)
    else
      ""
    end
  end

  def work_message(mobile: false, mine: false)
    return "" if object.work.blank?
    return "日報#{work_info}に記載済みです。" if mobile
    cancel_url = ""
    cancel_url = h.link_to('取消', h.task_work_path(task_id: object.task_id, id: object.work_id), data: { turbo_confirm: '作業を取消してよろしいですか？(作業そのものは削除されません)', turbo_method: :delete }, class: 'btn btn-sm p-0 btn-danger') if mine

    h.content_tag(:span, "日報") +
      h.link_to(work_info, h.work_path(object.work), target: :_blank, rel: :noopener) +
      h.content_tag(:span, "に記載済みです。") + cancel_url
  end
  
  def work_info
    return "" if object.work.blank?
    "#{work.worked_at}(#{work.name})"
  end
end
