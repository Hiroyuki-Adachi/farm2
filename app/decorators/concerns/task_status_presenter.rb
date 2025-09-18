module TaskStatusPresenter
  extend ActiveSupport::Concern

  included do
    # object は Draper::Decorator で wrap されているモデルを指す
  end

  def status_name(value)
    value.name
  end

  def status_badge(value)
    h.content_tag(:span, status_name(value), class: value.badge_class)
  end
end
