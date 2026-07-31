module TaskStatusPresenter
  extend ActiveSupport::Concern

  included do
    # object は Draper::Decorator で wrap されているモデルを指す
  end

  def status_name(value)
    value.name
  end

  def status_badge(value)
    h.render(Tasks::BadgeComponent.new(text: status_name(value), css_class: value.badge_class))
  end
end
