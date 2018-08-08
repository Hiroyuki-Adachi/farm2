# == Schema Information
#
# Table name: work_whole_crops # WCS作業
#
#  id         :bigint(8)        not null, primary key
#  work_id    :integer          not null               # 作業
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  unit_price :decimal(5, 2)    default(0.0), not null # 標準単価
#  tax_rate   :decimal(3, 1)    default(0.0), not null # 消費税率
#

class WorkWholeCrop < ApplicationRecord
  belongs_to :work

  has_many :wcs_lands, -> {order("whole_crop_rolls.display_order")}, {class_name: "WholeCropLand", dependent: :destroy}
  has_many :wcs_rolls, {through: :wcs_lands}

  scope :usual, ->(term) {joins(:work).where(["works.term = ?", term]).order("works.worked_at, works.id")}

  def self.regist(work, params)
    if work.whole_crop
      work.whole_crop.update(params)
    else
      WorkWholeCrop.create(params)
    end
  end

  def rolls
    wcs_lands.sum(:rolls)
  end

  def weight
    wcs_rolls.count.zero? ? 0 : (wcs_rolls.sum(:weight) / wcs_rolls.count).floor(1)
  end
end
