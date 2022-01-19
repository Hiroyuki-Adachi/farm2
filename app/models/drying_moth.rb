# == Schema Information
#
# Table name: drying_moths
#
#  id            :integer          not null, primary key
#  drying_id     :integer          default("0"), not null
#  moth_count    :integer          default("0"), not null
#  moth_no       :integer
#  water_content :decimal(3, 1)
#  moth_weight   :decimal(5, 1)
#  rice_weight   :decimal(5, 1)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  drying_moths_secondary  (drying_id,moth_count) UNIQUE
#

class DryingMoth < ApplicationRecord
  belongs_to :drying

  MAX_COUNT = 5
end
