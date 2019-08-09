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

require 'test_helper'

class AdjustmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
