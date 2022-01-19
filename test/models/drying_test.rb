# == Schema Information
#
# Table name: dryings
#
#  id             :integer          not null, primary key
#  term           :integer          not null
#  work_type_id   :integer
#  home_id        :integer          default("0"), not null
#  drying_type_id :integer          default("0"), not null
#  carried_on     :date             not null
#  shipped_on     :date
#  water_content  :decimal(3, 1)
#  fixed_amount   :decimal(7, )
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  copy_flag      :integer          default("0"), not null
#
# Indexes
#
#  dryings_secondary  (carried_on,home_id,copy_flag) UNIQUE
#

require 'test_helper'

class DryingTest < ActiveSupport::TestCase
  test "乾燥調整価格" do
    drying1 = dryings(:drying1)
    drying2 = dryings(:drying2)
    system2015 = systems(:s2015)
    adjustment1 = adjustments(:adjustment1)
    moth1 = drying_moths(:drying1_moth1)
    moth2 = drying_moths(:drying1_moth2)
    rice_weight1 = moth1.rice_weight + moth2.rice_weight

    assert_equal adjustment1.rice_bag * system2015.dry_adjust_price, drying2.amount(system2015, drying2.home_id)
    assert_equal adjustment1.waste_weight / Drying::KG_PER_BAG_WASTE * system2015.waste_price, drying2.waste_amount(system2015)
    assert_equal rice_weight1 / Drying::KG_PER_BAG_RICE * system2015.dry_price, drying1.amount(system2015, drying1.home_id)
  end
end
