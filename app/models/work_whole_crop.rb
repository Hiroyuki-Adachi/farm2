# == Schema Information
#
# Table name: work_whole_crops(WCS作業)
#
#  id                   :bigint           not null, primary key
#  article_name(品名)   :string(15)       default(""), not null
#  tax_rate(消費税率)   :decimal(3, 1)    default(0.0), not null
#  unit_price(標準単価) :decimal(5, 2)    default(0.0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  work_id(作業)        :integer          not null
#
# Indexes
#
#  index_work_whole_crops_on_work_id  (work_id) UNIQUE
#

class WorkWholeCrop < ApplicationRecord
  belongs_to :work

  has_many :wcs_lands, -> {order("whole_crop_lands.display_order")}, class_name: "WholeCropLand", dependent: :destroy
  has_many :wcs_rolls, through: :wcs_lands

  scope :usual, ->(term) {joins(:work).where(works: { term: term }).order("works.worked_at, works.id")}
  scope :for_harvest, ->(term) {
    joins(work: :work_type).where(works: { term: term })
    .order("work_types.display_order, works.worked_at, works.id")
  }

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
    wcs_lands.sum(:rolls) || 0
  end

  def weight
    wcs_rolls.valid.none? ? 0 : (wcs_rolls.sum(:weight) / wcs_rolls.valid.count).floor(1)
  end

  def self.whole_crop_params(params)
    params.permit(:id, :work_id)
  end

  def price
    (weight.round(0) * unit_price * rolls).round(0)
  end

  def self.update_prices(sys)
    # rubocop:disable Rails/SkipsModelValidations
    joins(:work).where(works: { term: sys.term }).update_all("unit_price = #{sys.roll_price}")
    # rubocop:enable Rails/SkipsModelValidations
  end
end
