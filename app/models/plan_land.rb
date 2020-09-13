# == Schema Information
#
# Table name: plan_lands # 作付計画
#
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  land_id(土地)          :integer          not null
#  work_type_id(作業分類) :integer          not null
#
# Indexes
#
#  plan_lands_2nd  (land_id) UNIQUE
#
class PlanLand < ApplicationRecord
  belongs_to :land
  belongs_to :work_type

  def self.create_all(params)
    PlanLand.delete_all
    params.each do |param|
      PlanLand.create(land_id: param[0], work_type_id: param[1]) if param[1].present?
    end
  end

  def self.clear_all(target)
    PlanLand.delete_all
    Land.regionable.each do |land|
      PlanLand.create(land_id: land.id, work_type_id: land.cost(target).work_type_id)
    end
  end
end
