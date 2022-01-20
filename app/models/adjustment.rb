# == Schema Information
#
# Table name: adjustments
#
#  id             :integer          not null, primary key
#  drying_id      :integer          default("0"), not null
#  home_id        :integer
#  carried_on     :date
#  shipped_on     :date
#  rice_bag       :decimal(3, )
#  half_weight    :decimal(3, 1)
#  waste_weight   :decimal(5, 1)
#  fixed_amount   :decimal(7, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  container_flag :boolean          default("false"), not null
#  waste_date     :date
#
# Indexes
#
#  adjustments_secondary  (drying_id) UNIQUE
#

class Adjustment < ApplicationRecord
  belongs_to :drying
  belongs_to :home, -> {with_deleted}

  def rice_weight(system)
    (rice_bag || 0) * Drying::KG_PER_BAG_RICE + (system.half_sum_flag ? (half_weight || 0) : 0)
  end

  def container_weight
    (rice_bag || 0) * Drying::KG_PER_BAG_RICE + (half_weight || 0)
  end

  def waste_bag
    waste_weight ? waste_weight / Drying::KG_PER_BAG_WASTE : nil
  end

  def waste_bag=(val)
    self.waste_weight = val ? val.to_d * Drying::KG_PER_BAG_WASTE : nil
  end
end
