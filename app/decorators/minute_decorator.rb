class MinuteDecorator < Draper::Decorator
  delegate_all
  decorates_association :schedule
end
