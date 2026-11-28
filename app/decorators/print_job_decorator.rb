class PrintJobDecorator < Draper::Decorator
  delegate_all

  STATUS_CLASSES = {
    "waiting" => "bg-secondary",
    "claimed" => "bg-info text-dark",
    "submitted" => "bg-success",
    "failed" => "bg-danger",
    "unknown" => "bg-warning text-dark",
    "canceled" => "bg-light text-dark border"
  }.freeze

  def status_name
    I18n.t("activerecord.enums.print_job.statuses.#{object.status}")
  end

  def status_badge
    h.content_tag(:span, status_name, class: "badge #{STATUS_CLASSES.fetch(object.status)}")
  end

  def requested_by_name
    worker = object.requested_by&.worker
    worker ? "#{worker.family_name} #{worker.first_name}" : "(削除された利用者)"
  end

  def requested_at
    object.created_at.strftime("%Y-%m-%d %H:%M")
  end
end
