# == Schema Information
#
# Table name: land_costs # 土地原価
#
#  id           :integer          not null, primary key  # 土地原価
#  term         :integer          not null               # 年度(期)
#  land_id      :integer          not null               # 土地
#  work_type_id :integer          not null               # 作業分類
#  cost         :decimal(7, 1)    default(0.0), not null # 原価
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class LandCost < ActiveRecord::Base
  belongs_to :land, -> {with_deleted}
  belongs_to :work_type, -> {with_deleted}

  validates :term, presence: true
  validates :land_id, presence: true
  validates :work_type_id, presence: true
  validates :cost, presence: true

  scope :usual, ->(lands, term) {where(["land_id IN (?) AND term = ?", lands.ids, term])}
  scope :total, ->(term) {joins(:land).where(term: term).group(:work_type_id).sum("lands.area")}

  def regist(params)
  end
end
