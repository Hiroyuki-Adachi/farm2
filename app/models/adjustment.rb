# == Schema Information
#
# Table name: adjustments # 調整
#
#  id           :bigint           not null, primary key
#  drying_id    :integer          default(0), not null  # 乾燥
#  home_id      :integer                                # 担当世帯
#  carried_on   :date                                   # 搬入日
#  shipped_on   :date                                   # 出荷日
#  rice_weight  :decimal(5, 1)                          # 調整米(kg)
#  waste_weight :decimal(5, 1)                          # くず米(kg)
#  fixed_amount :decimal(7, )                           # 確定額
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Adjustment < ApplicationRecord
  belongs_to :drying
  belongs_to :home, -> {with_deleted}

  def rice_bag
    return rice_weight.div(Drying::KG_PER_BAG)
  end

  def half_weight
    return rice_weight % Drying::KG_PER_BAG
  end
end
