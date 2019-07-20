# == Schema Information
#
# Table name: adjustments # 調整
#
#  id           :bigint           not null, primary key
#  drying_id    :integer          default(0), not null  # 乾燥
#  home_id      :integer                                # 担当世帯
#  carried_on   :date                                   # 搬入日
#  shipped_on   :date                                   # 出荷日
#  rice_bag     :decimal(3, )                           # 調整米(袋)
#  half_weight  :decimal(3, 1)                          # 半端米(kg)
#  waste_weight :decimal(5, 1)                          # くず米(kg)
#  fixed_amount :decimal(7, )                           # 確定額
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Adjustment < ApplicationRecord
  belongs_to :drying
  belongs_to :home, -> {with_deleted}

  def rice_weight
    return (rice_bag || 0) * Drying::KG_PER_BAG + (half_weight || 0)
  end
end