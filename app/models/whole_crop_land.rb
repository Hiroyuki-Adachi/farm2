# == Schema Information
#
# Table name: whole_crop_lands # WCS土地
#
#  id                          :bigint           not null, primary key
#  display_order(番号)         :integer          default(0), not null
#  rolls(ロール数)             :decimal(3, )     default(0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  work_land_id(作業地)        :integer          default(0), not null
#  work_whole_crop_id(WCS作業) :integer          default(0), not null
#
# Indexes
#
#  index_whole_crop_lands_on_work_whole_crop_id_and_work_land_id  (work_whole_crop_id,work_land_id) UNIQUE
#

class WholeCropLand < ApplicationRecord
  belongs_to :work_whole_crop
  belongs_to :work_land

  has_many :wcs_rolls, -> {order("whole_crop_rolls.display_order")}, {class_name: "WholeCropRoll", dependent: :destroy}

  scope :for_sales, ->(term) {
    joins(work_whole_crop: :work).where(["works.term = ?", term]).where.not(rolls: 0)
  }

  def self.regist(whole_crop, params)
    params.each do |param|
      wcs_land = nil
      if param[:id].present?
        wcs_land = WholeCropLand.find(param[:id])
        wcs_land.update(wcs_lands_param(whole_crop, param))
      else
        wcs_land = WholeCropLand.create(wcs_lands_param(whole_crop, param))
      end
      WholeCropRoll.regist(wcs_land, param.require(:wcs_rolls))
    end
  end

  def self.wcs_lands_param(whole_crop, param)
    param.permit(:id, :work_land_id, :display_order, :rolls).merge(work_whole_crop_id: whole_crop.id)
  end

  def price
    (rolls * work_whole_crop.roll_price * (100 + work_whole_crop.tax_rate) / 100).floor(0)
  end
end
