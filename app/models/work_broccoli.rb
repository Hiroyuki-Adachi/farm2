# == Schema Information
#
# Table name: work_broccolis # ブロッコリー作業
#
#  id              :integer          not null, primary key # ブロッコリー作業
#  work_id         :integer          not null              # 作業
#  broccoli_box_id :integer                                # 箱
#  shipped_on      :date             not null              # 出荷日
#  rest            :decimal(3, )     default(0), not null  # 残数
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sale            :decimal(6, )                           # 販売金額
#  cost            :decimal(6, )                           # 販売経費
#

class WorkBroccoli < ApplicationRecord
  require 'ostruct'

  validates :work_id, presence: true
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
        if inspection.to_i.positive?
          harvest.inspection = inspection
          harvest.save!
        else
          harvest.destroy
        end
      end
    end
  end

  def self.regist_sales(params)
    transaction do
      params[:work_broccoli].each do |param|
        work_broccoli = nil
        if param[:id].present?
          work_broccoli = WorkBroccoli.find(param[:id])
          work_broccoli.attributes = param
        else
          work_broccoli = WorkBroccoli.new(param)
        end
        work_broccoli.save if work_broccoli.present?
      end
    end
  end
end
