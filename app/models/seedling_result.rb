# == Schema Information
#
# Table name: seedling_results
#
#  id(育苗結果)               :integer          not null, primary key
#  display_order(表示順)      :integer          default(0), not null
#  disposal_flag(廃棄フラグ)  :boolean          default(FALSE), not null
#  quantity(苗箱数)           :decimal(3, )     default(0), not null
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  seedling_home_id(育苗担当) :integer
#  work_result_id(作業結果)   :integer
#

class SeedlingResult < ActiveRecord::Base
  belongs_to :seedling_home
  belongs_to :work_result

  scope :total, ->(seedling_homes) {where(seedling_home_id: seedling_homes.ids).group(:seedling_home_id).sum(:quantity)}

  scope :by_work_day, -> (seedling_home) {
    joins(work_result: :work)
    .where(seedling_home_id: seedling_home.id)
    .group("works.worked_at")
    .order("works.worked_at")
    .sum(:quantity)
  }

  def work_id
    work_result&.work_id
  end

  def self.dispose?(seedling_home, worked_at)
    joins(work_result: :work)
    .exists?(["seedling_results.seedling_home_id = ? AND works.worked_at = ? AND disposal_flag = TRUE", seedling_home.id, worked_at])
  end
end
