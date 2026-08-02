# == Schema Information
#
# Table name: seedling_results(育苗結果)
#
#  id(育苗結果)               :integer          not null, primary key
#  disposal_flag(廃棄フラグ)  :boolean          default(FALSE), not null
#  quantity(苗箱数)           :decimal(3, )     default(0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  seedling_home_id(育苗担当) :integer
#  work_result_id(作業結果)   :integer
#

class SeedlingResult < ApplicationRecord
  belongs_to :seedling_home
  belongs_to :work_result

  scope :for_organization, lambda { |organization|
    joins(:seedling_home).merge(SeedlingHome.for_organization(organization))
  }

  scope :total, ->(seedling_homes) { where(seedling_home_id: seedling_homes.pluck(:id)).group(:seedling_home_id).sum(:quantity) }
  scope :for_seedling_use, lambda {
    joins(work_result: :work)
      .order("works.worked_at ASC, works.id ASC, seedling_results.id ASC")
  }

  scope :by_work_day, lambda { |seedling_home|
    joins(work_result: :work)
      .where(seedling_home_id: seedling_home.id)
      .group("works.worked_at")
      .order("works.worked_at")
      .sum(:quantity)
  }

  validate :work_result_belongs_to_same_organization

  def work_id
    work_result&.work_id
  end

  def self.dispose?(seedling_home, worked_at)
    joins(work_result: :work)
      .exists?(["seedling_results.seedling_home_id = ? AND works.worked_at = ? AND disposal_flag = TRUE", seedling_home.id, worked_at])
  end

  private

  def work_result_belongs_to_same_organization
    return if seedling_home&.home.blank? || work_result&.work.blank?
    return if seedling_home.home.organization_id == work_result.work.organization_id

    errors.add(:work_result_id, "は育苗担当世帯と同じ組織の作業実績を指定してください。")
  end
end
