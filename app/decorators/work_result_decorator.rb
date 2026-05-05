class WorkResultDecorator < Draper::Decorator
  delegate_all
  decorates_association :work

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def worker_name(organization)
    if organization.print_home?
      return "#{model.worker.name}(#{model.worker.home.name})"
    elsif organization.print_section?
      return "#{model.worker.name}(#{model.worker.home.section.name})"
    end

    model.worker.name
  end

  def home_name
    model.worker.home.name
  end

  def name
    "#{work.work_type.name}(#{work_name})"
  end

  def worked_at
    model.work.worked_at.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.work.worked_at.wday]})"
  end

  def worked_at_short
    model.work.worked_at.strftime('%m/%d') + "(#{I18n.t('date.abbr_day_names')[model.work.worked_at.wday]})"
  end

  def work_type_name
    "#{model.work.work_type&.category_name}(#{model.work.work_type&.name})"
  end

  def work_kind_short_name
    work.work_kind.name.slice(0, 7)
  end

  delegate :name, to: :work, prefix: true

  def work_short_name
    work.model.name.slice(0..9)
  end

  def work_name_short
    "#{model.work.work_type.name}(#{model.work.work_kind.name})"
  end

  def hours
    "%.1f" % model.hours
  end

  def price
    h.number_to_currency(model.price, { precision: 0, unit: "" })
  end

  def amount
    h.number_to_currency(model.amount, { precision: 0, unit: "" })
  end
end
