# == Schema Information
#
# Table name: total_cost_details
#
#  id            :integer          not null, primary key
#  total_cost_id :integer          not null
#  work_type_id  :integer          not null
#  rate          :decimal(6, 2)    default("1"), not null
#  area          :decimal(7, 2)    not null
#  cost          :decimal(9, )
#  base_cost     :decimal(9, 3)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_total_cost_details_on_total_cost_id_and_work_type_id  (total_cost_id,work_type_id) UNIQUE
#

class TotalCostDetail < ApplicationRecord
  belongs_to :total_cost
  belongs_to :work_type

  scope :lands, ->(term, days) {
    joins(:total_cost)
      .where(["total_costs.term = ?", term])
      .where(["total_costs.total_cost_type_id = ?", TotalCostType::LAND.id])
      .group("total_cost_details.work_type_id")
      .sum("total_cost_details.area * total_cost_details.rate / #{days}")
  }

  scope :total_machines, ->(term) {
    joins(:total_cost).includes(:total_cost)
      .where(["total_costs.term = ?", term])
      .where(["total_costs.total_cost_type_id = ?", TotalCostType::MACHINE.id])
      .group(["total_cost_details.work_type_id", "total_costs.machine_id"])
      .sum("total_cost_details.cost")
  }

  scope :areas, ->(term, days) {
    joins(:total_cost)
      .where(["total_costs.term = ?", term])
      .where(["total_costs.total_cost_type_id = ?", TotalCostType::AREA.id])
      .group("total_cost_details.work_type_id")
      .sum("total_cost_details.area * total_cost_details.rate / #{days}")
  }
end
