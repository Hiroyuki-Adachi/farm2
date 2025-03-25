class TotalCostsMakeJob < ApplicationJob
  queue_as :default

  def perform(term, fixed_on)
    TotalCost.transaction do
      TotalCost.make(term, fixed_on)
    end
  end
end
