# == Schema Information
#
# Table name: drying_lands
#
#  id            :integer          not null, primary key
#  drying_id     :integer          default("0"), not null
#  land_id       :integer
#  display_order :integer          default("0"), not null
#  percentage    :decimal(4, 1)    default("100"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
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
