# == Schema Information
#
# Table name: drying_moths # 乾燥籾
#
#  id                    :bigint           not null, primary key
#  moth_count(回数)      :integer          default(0), not null
#  moth_no(No.)          :integer
#  moth_weight(籾(kg))   :decimal(5, 1)
#  rice_weight(玄米(kg)) :decimal(5, 1)
#  water_content(水分)   :decimal(3, 1)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  drying_id(乾燥調整)   :integer          default(0), not null
#
# Indexes
#
#  drying_moths_secondary  (drying_id,moth_count) UNIQUE
#

class DryingMoth < ApplicationRecord
  belongs_to :drying

  MAX_COUNT = 4
end
