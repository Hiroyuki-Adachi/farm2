# == Schema Information
#
# Table name: whole_crop_rolls # WCSロール
#
#  id                 :bigint(8)        not null, primary key
#  whole_crop_land_id :integer          default(0), not null   # WCS土地
#  display_order      :integer          default(0), not null   # 番号
#  weight             :decimal(4, 1)    default(0.0), not null # 重量
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
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
