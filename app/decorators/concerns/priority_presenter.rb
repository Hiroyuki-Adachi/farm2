# app/decorators/concerns/priority_presenter.rb
module PriorityPresenter
  extend ActiveSupport::Concern

  included do
    # object は Draper::Decorator で wrap されているモデルを指す
  end

  def priority_name(value)
    I18n.t("activerecord.enums.task.priorities.#{value}")
  end

  def priority_color(value)
    I18n.t("activerecord.enums.task.priority_colors.#{value}")
  end

  def priority_badge(value)
    h.render(Tasks::BadgeComponent.new(text: priority_name(value), css_class: "badge text-bg-#{priority_color(value)}"))
  end
end
