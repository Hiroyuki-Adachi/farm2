# == Schema Information
#
# Table name: broccoli_harvests
#
#  id               :integer          not null, primary key
#  work_broccoli_id :integer          not null
#  broccoli_rank_id :integer          not null
#  broccoli_size_id :integer          not null
#  inspection       :decimal(3, )     default("0"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
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
