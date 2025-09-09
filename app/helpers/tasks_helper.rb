module TasksHelper
  def status_badge(task)
    cls = task.closed? ? "text-bg-secondary" : "text-bg-primary"
    content_tag(:span, task.task_status.name, class: "badge #{cls}")
  end
end
