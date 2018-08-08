# == Schema Information
#
# Table name: whole_crop_lands # WCS土地
#
#  id                 :bigint(8)        not null, primary key
#  work_whole_crop_id :integer          default(0), not null  # WCS作業
#  work_land_id       :integer          default(0), not null  # 作業地
#  display_order      :integer          default(0), not null  # 番号
#  rolls              :decimal(3, )     default(0), not null  # ロール数
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class WholeCropLand < ApplicationRecord
  belongs_to :work_whole_crop
  belongs_to :work_land

  has_many :wcs_rolls, -> {order("whole_crop_rolls.display_order")}, {class_name: "WholeCropRoll", dependent: :destroy}
end
