class WholeCropDecorator < Draper::Decorator
  delegate_all
  decorates_association :work

  def price
    model.price.to_i.to_s(:delimited)
  end

  def roll_price
    model.roll_price.to_i.to_s(:delimited)
  end

  def tax_amount
    model.tax_amount.to_i.to_s(:delimited)
  end

  def amount
    model.amount.to_i.to_s(:delimited)
  end

  def weight
    model.weight.floor(0).to_i
  end

  def rolls
    model.rolls.to_i
  end
end
