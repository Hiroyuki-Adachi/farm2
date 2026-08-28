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
  scope :usual, lambda { |user, term|
    where(user_id: user.id, term: term)
      .joins(:land, :work_type)
      .order("work_types.display_order, plan_lands.work_type_id, lands.place")
  }

  validate :land_belongs_to_user_organization

  def self.create_all(user, term, params, organization)
    assignments = {}
    params.each_pair do |land_id, work_type_id|
      assignments[land_id.to_s] = work_type_id.to_s if work_type_id.present?
    end
    validate_assignment_ids!(user, assignments, organization)
    replace_all(user.id, term, assignments)
  end

  def self.clear_all(user, term, target, organization)
    validate_user_organization!(user, organization)
    land_ids = Land.for_organization(organization).regionable.expiry(target).select(:id)
    assignments = LandCost.newest(target)
      .where(land_id: land_ids)
      .pluck(:land_id, :work_type_id)
      .to_h
    replace_all(user.id, term, assignments)
  end

  def self.validate_assignment_ids!(user, assignments, organization)
    validate_user_organization!(user, organization)

    land_ids = assignments.keys.to_set(&:to_i)
    valid_land_ids = Land.for_organization(organization).where(id: land_ids.to_a).ids.to_set
    raise ActiveRecord::RecordNotFound, "Land is outside the organization" unless land_ids == valid_land_ids

    work_type_ids = assignments.values.to_set(&:to_i)
    valid_work_type_ids = WorkType.where(id: work_type_ids.to_a).ids.to_set
    return if work_type_ids == valid_work_type_ids

    raise ActiveRecord::RecordNotFound, "Work type does not exist"
  end
  private_class_method :validate_assignment_ids!

  def self.validate_user_organization!(user, organization)
    organization_id = organization.is_a?(Organization) ? organization.id : organization.to_i
    return if user.organization_id == organization_id

    raise ActiveRecord::RecordNotFound, "User is outside the organization"
  end
  private_class_method :validate_user_organization!

  def self.replace_all(user_id, term, assignments)
    now = Time.current
    records = assignments.map do |land_id, work_type_id|
      {
        user_id: user_id,
        term: term,
        land_id: land_id,
        work_type_id: work_type_id,
        created_at: now,
        updated_at: now
      }
    end

    transaction do
      where(user_id: user_id, term: term).delete_all
      # Organization, land, and work type IDs are validated before this bulk insert.
      insert_all!(records) if records.any? # rubocop:disable Rails/SkipsModelValidations
    end
  end
  private_class_method :replace_all

  private

  def land_belongs_to_user_organization
    return if land.blank? || user.blank? || land.organization_id == user.organization_id

    errors.add(:land_id, "は利用者と同じ組織の土地を指定してください。")
  end
end
