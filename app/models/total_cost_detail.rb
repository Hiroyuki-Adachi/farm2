# == Schema Information
#
# Table name: total_cost_details # 集計原価(明細)
#
#  id                      :bigint           not null, primary key
#  area(面積(α))           :decimal(7, 2)    not null
#  base_cost(原価(10α当))  :decimal(9, 3)
#  cost(原価)              :decimal(9, )
#  rate(割合)              :decimal(6, 2)    default(1.0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  total_cost_id(集計原価) :integer          not null
#  work_type_id(作業分類)  :integer          not null
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
end
