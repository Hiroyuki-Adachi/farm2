# == Schema Information
#
# Table name: drying_moths # 乾燥籾
#
#  id            :bigint           not null, primary key
#  drying_id     :integer          default(0), not null  # 乾燥調整
#  moth_count    :integer          default(0), not null  # 回数
#  moth_no       :integer                                # No.
#  water_content :decimal(3, 1)                          # 水分
#  moth_weight   :decimal(5, 1)                          # 籾(kg)
#  rice_weight   :decimal(5, 1)                          # 玄米(kg)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class DryingMoth < ApplicationRecord
  belongs_to :drying

  MAX_COUNT = 4
end
