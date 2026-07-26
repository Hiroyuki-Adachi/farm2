# == Schema Information
#
# Table name: plan_seedlings(育苗計画)
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

  scope :for_organization, ->(organization) { joins(:home).merge(Home.for_organization(organization)) }

  def self.usual(organization = nil)
    results = Hash.new { |h, k| h[k] = {} }
    seedlings = organization ? for_organization(organization) : all
    seedlings.find_each do |seedling|
      results[seedling.home_id][seedling.plan_work_type_id] = seedling
    end
    results
  end

  def self.create_all(params, organization = nil)
    transaction do
      params.each do |hid, param|
        home = organization ? Home.for_organization(organization).find(hid) : Home.find(hid)
        param.each do |pid, q|
          pl = find_or_initialize_by(home: home, plan_work_type_id: pid)
          pl.quantity = q[:quantity]
          pl.save!
        end
      end
      base = joins(:home).where(homes: { seedling_order: nil })
      base = base.for_organization(organization) if organization
      base.destroy_all
    end
  end

  def seeds
    (quantity * (plan&.seeds || 0) / 1000).ceil
  end

  def soil_bag
    (quantity * (plan&.soils || 0)).ceil
  end

  def seed_bag1
    return 0 if plan&.bag_weight1.nil? || plan.bag_weight1.zero?

    plan.bag_weight2.zero? ? (seeds / plan.bag_weight1).ceil : (seeds / plan.bag_weight1).floor
  end

  def seed_bag2
    return 0 if plan&.bag_weight2.nil? || plan.bag_weight2.zero?

    ((seeds - (seed_bag1 * plan.bag_weight1)) / plan.bag_weight2).ceil
  end
end
