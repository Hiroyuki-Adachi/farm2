# == Schema Information
#
# Table name: seedling_results # 育苗結果
#
#  id               :integer          not null, primary key    # 育苗結果
#  seedling_home_id :integer                                   # 育苗担当
#  work_result_id   :integer                                   # 作業結果
#  display_order    :integer          default(0), not null     # 表示順
#  quantity         :decimal(3, )     default(0), not null     # 苗箱数
#  disposal_flag    :boolean          default(FALSE), not null # 廃棄フラグ
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class SeedlingResult < ActiveRecord::Base
  belongs_to :seedling_home
  belongs_to :work_result, {dependent: :destroy}

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
