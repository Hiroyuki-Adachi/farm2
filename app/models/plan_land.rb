# == Schema Information
#
# Table name: plan_lands
#
#  land_id      :integer          not null
#  work_type_id :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          default("0"), not null
#
# Indexes
#
#  plan_lands_2nd  (user_id,land_id) UNIQUE
#

class PlanLand < ApplicationRecord
  belongs_to :land
  belongs_to :work_type
  belongs_to :user

  def self.create_all(user_id, params)
    PlanLand.where(user_id: user_id).delete_all
    params.each do |param|
      PlanLand.create(user_id: user_id, land_id: param[0], work_type_id: param[1]) if param[1].present?
    end
  end

  def self.clear_all(user_id, target)
    PlanLand.where(user_id: user_id).delete_all
    Land.regionable.each do |land|
      land_cost = land.cost(target)
      PlanLand.create(user_id: user_id, land_id: land.id, work_type_id: land_cost.work_type_id) if land_cost
    end
  end
end
