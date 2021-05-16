# == Schema Information
#
# Table name: whole_crop_rolls
#
#  id                          :bigint           not null, primary key
#  display_order(番号)         :integer          default(0), not null
#  weight(重量)                :decimal(4, 1)    default(0.0), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  whole_crop_land_id(WCS土地) :integer          default(0), not null
#
class WholeCropRoll < ApplicationRecord
  MAX_ROLLS = 5

  scope :valid, -> {where("weight > ?", 0)}

  belongs_to :wcs_land, {class_name: "WholeCropLand", foreign_key: "whole_crop_land_id"}

  def self.regist(wcs_land, params)
    params.each do |param|
      if param[:id].present?
        WholeCropRoll.find(param[:id]).update(wcs_roll_param(wcs_land, param))
      else
        WholeCropRoll.create(wcs_roll_param(wcs_land, param))
      end
    end
  end

  def self.wcs_roll_param(wcs_land, param)
    param.permit(:id, :display_order, :weight).merge(whole_crop_land_id: wcs_land.id)
  end
end
