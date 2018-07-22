class WholeCropDecorator < Draper::Decorator
  delegate_all
  decorates_association :work
end
