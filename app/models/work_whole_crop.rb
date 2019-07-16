# == Schema Information
#
# Table name: work_whole_crops # WCS作業
#
#  id           :bigint           not null, primary key
#  work_id      :integer          not null               # 作業
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  unit_price   :decimal(5, 2)    default(0.0), not null # 標準単価
#  tax_rate     :decimal(3, 1)    default(0.0), not null # 消費税率
#  article_name :string(15)       default(""), not null  # 品名
#

class WorkWholeCrop < ApplicationRecord
  belongs_to :work

  has_many :wcs_lands, -> {order("whole_crop_lands.display_order")}, {class_name: "WholeCropLand", dependent: :destroy}
  has_many :wcs_rolls, {through: :wcs_lands}

  scope :usual, ->(term) {joins(:work).where(["works.term = ?", term]).order("works.worked_at, works.id")}

  def self.regist(work, params)
    work_whole_crop = work.whole_crop
    if work_whole_crop
      work_whole_crop.update(whole_crop_params(params))
    else
      work_whole_crop = WorkWholeCrop.create(whole_crop_params(params))
    end
    WholeCropLand.regist(work_whole_crop, params.require(:wcs_lands))
  end

  def rolls
    wcs_lands.sum(:rolls)
  end

  def weight
    wcs_rolls.valid.count.zero? ? 0 : (wcs_rolls.sum(:weight) / wcs_rolls.valid.count).floor(1)
  end

  def self.whole_crop_params(params)
    params.permit(:id, :work_id)
  end

  def roll_price
    weight.floor(0) * unit_price
  end

  def price
    roll_price * rolls
  end

  def tax_amount
    (price * tax_rate / 100).floor(0)
  end

  def amount
    price + tax_amount
  end
end
