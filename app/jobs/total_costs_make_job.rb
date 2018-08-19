class TotalCostsMakeJob < ApplicationJob
  queue_as :default

  def perform(term, organization)
    TotalCost.transaction do
      TotalCost.make(term, organization)
    end
  end
end
