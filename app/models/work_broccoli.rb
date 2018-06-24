# == Schema Information
#
# Table name: work_broccolis # ブロッコリー作業
#
#  id              :integer          not null, primary key # ブロッコリー作業
#  work_id         :integer          not null              # 作業
#  broccoli_box_id :integer          not null              # 箱
#  shipped_on      :date             not null              # 出荷日
#  rest            :decimal(3, )     default(0), not null  # 残数
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class WorkBroccoli < ApplicationRecord
  require 'ostruct'

  validates :work_id, presence: true
  validates :broccoli_box_id, presence: true
  validates :shipped_on, presence: true
  validates :rest, presence: true

  belongs_to :work
  belongs_to :box, class_name: "BroccoliBox", foreign_key: :broccoli_box_id

  has_many :harvests, class_name: "BroccoliHarvest", foreign_key: :work_broccoli_id, dependent: :destroy

  def harvest(rank, size)
    return nil unless harvests
    harvests.find { |h| h.broccoli_rank_id == rank.id && h.broccoli_size_id == size.id}
  end

  def regist_harvests(params)
    params.each do |rank_id, sizes|
      sizes.each do |size_id, inspection|
        harvest = BroccoliHarvest.find_or_initialize_by(broccoli_rank_id: rank_id, broccoli_size_id: size_id, work_broccoli_id: self.id)
        if inspection.to_i > 0
          harvest.inspection = inspection
          harvest.save!
        else
          harvest.destroy
        end
      end
    end
  end
end
