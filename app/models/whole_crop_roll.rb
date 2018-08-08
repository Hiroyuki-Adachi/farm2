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

  belongs_to :wcs_land, {class_name: "WholeCropLand"}
end
