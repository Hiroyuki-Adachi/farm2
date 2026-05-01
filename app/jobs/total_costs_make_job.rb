class TotalCostsMakeJob < ApplicationJob
  queue_as :default

  def perform(organization_id, term, fixed_on)
    TotalCost.transaction do
      TotalCost.make(organization_id, term, fixed_on)
    end
  end
end
