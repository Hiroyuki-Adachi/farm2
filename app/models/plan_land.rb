# == Schema Information
#
# Table name: plan_lands(作付計画)
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

  scope :for_organization, ->(organization) { joins(:land).merge(Land.for_organization(organization)) }
  scope :usual, ->(user, term) { where(user_id: user.id, term: term).joins(:land).joins(:work_type).order("work_types.display_order, plan_lands.work_type_id, lands.place") }

  validate :land_belongs_to_user_organization

  def self.create_all(user, term, params, organization)
    transaction do
      where(user_id: user.id, term: term).delete_all
      params.each do |land_id, work_type_id|
        next if work_type_id.blank?

        land = Land.for_organization(organization).find(land_id)
        create!(user: user, term: term, land: land, work_type_id: work_type_id)
      end
    end
  end

  def self.clear_all(user_id, term, target, organization)
    PlanLand.where(user_id: user_id, term: term).delete_all
    Land.for_organization(organization).regionable.expiry(target).each do |land|
      land_cost = land.cost(target)
      PlanLand.create(user_id: user_id, term: term, land_id: land.id, work_type_id: land_cost.work_type_id) if land_cost
    end
  end

  private

  def land_belongs_to_user_organization
    return if land.blank? || user.blank? || land.organization_id == user.organization_id

    errors.add(:land_id, "は利用者と同じ組織の土地を指定してください。")
  end
end
