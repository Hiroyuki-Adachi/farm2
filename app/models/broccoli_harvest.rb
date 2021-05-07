# == Schema Information
#
# Table name: broccoli_harvests # ブロッコリー収穫
#
#  id(ブロッコリー収穫)               :integer          not null, primary key
#  inspection(検査後数量)             :decimal(3, )     default(0), not null
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  broccoli_rank_id(ブロッコリー等級) :integer          not null
#  broccoli_size_id(ブロッコリー階級) :integer          not null
#  work_broccoli_id(ブロッコリー作業) :integer          not null
#
# Indexes
#
#  broccoli_harvest_sheet  (work_broccoli_id,broccoli_rank_id,broccoli_size_id) UNIQUE
#
class BroccoliHarvest < ApplicationRecord
  validates :work_broccoli_id, presence: true
  validates :broccoli_rank_id, presence: true
  validates :broccoli_size_id, presence: true
  validates :inspection, presence: true

  belongs_to :work_broccoli
  belongs_to :rank, class_name: "BroccoliRank", foreign_key: :broccoli_rank_id
  belongs_to :size, class_name: "BroccoliSize", foreign_key: :broccoli_size_id
end
