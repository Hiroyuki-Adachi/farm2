# == Schema Information
#
# Table name: total_cost_details # 集計原価(明細)
#
#  id            :bigint(8)        not null, primary key
#  total_cost_id :integer          not null               # 集計原価
#  work_type_id  :integer          not null               # 作業分類
#  rate          :decimal(6, 2)    default(1.0), not null # 割合
#  area          :decimal(7, 2)    not null               # 面積(α)
#  cost          :decimal(9, )                            # 原価
#  base_cost     :decimal(9, 3)                           # 原価(10α当)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
