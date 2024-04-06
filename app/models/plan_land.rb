# == Schema Information
#
# Table name: plan_lands
#
#  term(年度)             :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  land_id(土地)          :integer          not null
#  user_id(利用者)        :integer          default(0), not null
#  work_type_id(作業分類) :integer          not null
#
# Indexes
#
#  plan_lands_2nd  (user_id,land_id,term) UNIQUE
#

class PlanLand < ApplicationRecord
  belongs_to :land
  belongs_to :work_type
  belongs_to :user

  scope :usual, ->(user, term){where(user_id: user.id, term: term).joins(:land).joins(:work_type).order("work_types.display_order, plan_lands.work_type_id, lands.place")}

  def self.create_all(user_id, term, params)
    PlanLand.where(user_id: user_id, term: term).delete_all
    params.each do |param|
      PlanLand.create(user_id: user_id, term: term, land_id: param[0], work_type_id: param[1]) if param[1].present?
    end
  end

  def self.clear_all(user_id, term, target)
    PlanLand.where(user_id: user_id, term: term).delete_all
    Land.regionable.expiry(target).each do |land|
      land_cost = land.cost(target)
      PlanLand.create(user_id: user_id, term: term, land_id: land.id, work_type_id: land_cost.work_type_id) if land_cost
    end
  end
end
