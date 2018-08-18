# == Schema Information
#
# Table name: land_costs # 土地原価
#
#  id           :integer          not null, primary key               # 土地原価
#  land_id      :integer          not null                            # 土地
#  work_type_id :integer          not null                            # 作業分類
#  cost         :decimal(7, 1)    default(0.0), not null              # 原価
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  activated_on :date             default(Mon, 01 Jan 1900), not null # 有効日
#

class LandCost < ApplicationRecord
  belongs_to :land, -> {with_deleted}
  belongs_to :work_type, -> {with_deleted}

  validates :activated_on, presence: true
  validates :land_id, presence: true
  validates :work_type_id, presence: true
  validates :cost, presence: true

  scope :newest, ->(target) {where([<<SQL, target])}
  EXISTS (
    SELECT land_id, MAX(activated_on)
      FROM land_costs lc2
      WHERE lc2.land_id = land_costs.land_id AND activated_on <= ?
      GROUP BY land_id
      HAVING MAX(activated_on) = land_costs.activated_on
  )
SQL

  scope :usual, ->(lands, target) {newest(target).where(land_id: lands.ids)}
  scope :by_work_type, ->(work_type_id, target) {newest(target).where(work_type_id: work_type_id)}

  scope :total, ->(target) {joins(:land).newest(target).group(:work_type_id).sum("lands.area")}

  def self.sum_area_by_lands(target, land_ids)
    LandCost.newest(target).where(land_id: land_ids).group(:work_type_id).joins(:land).sum(:area)
  end

  def self.sum_area_by_work_type(target, work_type_id)
    LandCost.by_work_type(work_type_id, target).joins(:land).sum(:area)
  end
end
