class TotalCostsMakeJob < ApplicationJob
  queue_as :default

  def perform(organization_id, term, fixed_on)
    TotalCost.transaction do
      TotalCost.make(organization_id, term, fixed_on)
      System.find_by!(organization_id: organization_id, term: term).update!(total_cost_fixed_on: fixed_on)
    end
  end
end
