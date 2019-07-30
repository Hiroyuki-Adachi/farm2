# == Schema Information
#
# Table name: broccoli_harvests # ブロッコリー収穫
#
#  id               :integer          not null, primary key
#  work_broccoli_id :integer          not null              # ブロッコリー作業
#  broccoli_rank_id :integer          not null              # ブロッコリー等級
#  broccoli_size_id :integer          not null              # ブロッコリー階級
#  inspection       :decimal(3, )     default(0), not null  # 検査後数量
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class BroccoliHarvest < ApplicationRecord
  validates :work_broccoli_id, presence: true
  validates :broccoli_rank_id, presence: true
  validates :broccoli_size_id, presence: true
  validates :inspection, presence: true

  belongs_to :work_broccoli
  belongs_to :rank, {class_name: "BroccoliRank", foreign_key: :broccoli_rank_id}
  belongs_to :size, {class_name: "BroccoliSize", foreign_key: :broccoli_size_id}
end
