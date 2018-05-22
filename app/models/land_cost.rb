# == Schema Information
#
# Table name: land_costs # 土地原価
#
#  id           :integer          not null, primary key  # 土地原価
#  term         :integer          not null               # 年度(期)
#  land_id      :integer          not null               # 土地
#  work_type_id :integer          not null               # 作業分類
#  cost         :decimal(7, 1)    default(0.0), not null # 原価
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class LandCost < ActiveRecord::Base
  belongs_to :land, -> {with_deleted}
  belongs_to :work_type, -> { with_deleted }
end
