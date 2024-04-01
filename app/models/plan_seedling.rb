# == Schema Information
#
# Table name: plan_seedlings
#
#  id                          :bigint           not null, primary key
#  quantity(枚数)              :decimal(4, )     default(0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  home_id(世帯)               :integer
#  plan_work_type_id(作業計画) :integer          not null
#
# Indexes
#
#  plan_seedlings_2nd  (plan_work_type_id,home_id) UNIQUE
#

class PlanSeedling < ApplicationRecord
  belongs_to :home
  belongs_to :plan, class_name: "PlanWorkType", foreign_key: "plan_work_type_id"

  def self.usual
    results = Hash.new { |h, k| h[k] = {} }
    PlanSeedling.all.each do |seedling|
      results[seedling.home_id][seedling.plan_work_type_id] = seedling
    end
    return results
  end

  def self.create_all(params)
    params.each do |hid, param|
      param.each do |pid, q|
        pl = PlanSeedling.find_by(home_id: hid, plan_work_type_id: pid)
        if pl.present?
          pl.quantity = q[:quantity]
        else
          pl = PlanSeedling.create(home_id: hid, plan_work_type_id: pid, quantity: q[:quantity])
        end
      end
    end
    PlanSeedling.joins(:home).where("homes.seedling_order IS NULL").destroy_all
  end

  def seeds
    return (quantity * (plan&.seeds || 0) / 1000).ceil
  end

  def soil_bag
    return (quantity * (plan&.soils || 0)).ceil
  end

  def seed_bag1
    return 0 if plan&.bag_weight1.nil? || plan.bag_weight1.zero?
    return plan.bag_weight2.zero? ? (seeds / plan.bag_weight1).ceil : (seeds / plan.bag_weight1).floor
  end

  def seed_bag2
    return 0 if plan&.bag_weight2.nil? || plan.bag_weight2.zero?
    return ((seeds - seed_bag1 * plan.bag_weight1) / plan.bag_weight2).ceil
  end
end
