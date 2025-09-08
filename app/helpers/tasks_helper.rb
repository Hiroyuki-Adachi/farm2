module TasksHelper
  def status_badge(task)
    tag_name = I18n.t("activerecord.attributes.task.statuses.#{task.status}")
    cls = task.closed? ? "text-bg-secondary" : "text-bg-primary"
    content_tag(:span, tag_name, class: "badge #{cls}")
  end
end
