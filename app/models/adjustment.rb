# == Schema Information
#
# Table name: adjustments
#
#  id                             :bigint           not null, primary key
#  carried_on(搬入日)             :date
#  container_flag(フレコンフラグ) :boolean          default(FALSE), not null
#  fixed_amount(確定額)           :decimal(7, )
#  half_weight(半端米(kg))        :decimal(3, 1)
#  rice_bag(調整米(袋))           :decimal(3, )
#  shipped_on(出荷日)             :date
#  waste_date(くず米出荷日)       :date
#  waste_weight(くず米(kg))       :decimal(5, 1)
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  drying_id(乾燥)                :integer          default(0), not null
#  home_id(担当世帯)              :integer
#
# Indexes
#
#  adjustments_secondary  (drying_id) UNIQUE
#

class Adjustment < ApplicationRecord
  belongs_to :drying
  belongs_to :home, -> {with_deleted}

  def rice_weight(system)
    ((rice_bag || 0) * Drying::KG_PER_BAG_RICE) + (system.half_sum_flag ? (half_weight || 0) : 0)
  end

  def container_weight
    ((rice_bag || 0) * Drying::KG_PER_BAG_RICE) + (half_weight || 0)
  end

  def waste_bag
    waste_weight ? waste_weight / Drying::KG_PER_BAG_WASTE : nil
  end

  def waste_bag=(val)
    self.waste_weight = val ? val.to_d * Drying::KG_PER_BAG_WASTE : nil
  end
end
