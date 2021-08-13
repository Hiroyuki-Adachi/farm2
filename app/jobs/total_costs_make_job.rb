class TotalCostsMakeJob < ApplicationJob
  queue_as :default

  def perform(term, organization, fixed_on)
    TotalCost.transaction do
      TotalCost.make(term, organization, fixed_on)
    end
  end
end
