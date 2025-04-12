# == Schema Information
#
# Table name: work_broccolis(ブロッコリー作業)
#
#  id(ブロッコリー作業) :integer          not null, primary key
#  cost(販売経費)       :decimal(6, )
#  rest(残数)           :decimal(3, )     default(0), not null
#  sale(販売金額)       :decimal(6, )
#  shipped_on(出荷日)   :date             not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  broccoli_box_id(箱)  :integer
#  work_id(作業)        :integer          not null
#
# Indexes
#
#  index_work_broccolis_on_work_id  (work_id) UNIQUE
#

class WorkBroccoli < ApplicationRecord
  require 'ostruct'

  validates :shipped_on, presence: true
  validates :rest, presence: true

  belongs_to :work
  belongs_to :box, class_name: "BroccoliBox", foreign_key: :broccoli_box_id

  has_many :harvests, class_name: "BroccoliHarvest", dependent: :destroy

  scope :for_sales, ->(term) {
    joins(:work)
      .where(["works.term = ? AND work_broccolis.sale > 0", term])
  }

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
