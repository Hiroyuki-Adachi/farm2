# == Schema Information
#
# Table name: plan_lands # 作付計画
#
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  land_id(土地)          :integer          not null
#  work_type_id(作業分類) :integer          not null
#
# Indexes
#
#  plan_lands_2nd  (land_id) UNIQUE
#
class PlanLand < ApplicationRecord
  belongs_to :land
  belongs_to :work_type
end
