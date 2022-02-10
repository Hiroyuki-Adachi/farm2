# == Schema Information
#
# Table name: drying_lands
#
#  id                    :bigint           not null, primary key
#  display_order(表示順) :integer          default(0), not null
#  percentage(割合)      :decimal(4, 1)    default(100.0), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  drying_id(乾燥調整)   :integer          default(0), not null
#  land_id(作業地)       :integer
#
# Indexes
#
#  drying_lands_3rd  (drying_id,display_order) UNIQUE
#

class DryingLand < ApplicationRecord
  belongs_to :drying
  belongs_to :land

  MAX_COUNT = 3
end
