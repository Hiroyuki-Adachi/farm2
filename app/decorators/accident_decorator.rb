class AccidentDecorator < Draper::Decorator
  delegate_all
  decorates_association :work
  decorates_association :investigator

  def investigated_on
    model.investigated_on.strftime('%Y-%m-%d') + "(#{I18n.t('date.abbr_day_names')[model.investigated_on.wday]})"
  end
end
