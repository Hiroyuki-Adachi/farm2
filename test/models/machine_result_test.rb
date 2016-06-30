# == Schema Information
#
# Table name: machine_results # 機械稼動データ
#
#  id              :integer          not null, primary key  # 機械稼動データ
#  machine_id      :integer                                 # 機械
#  work_result_id  :integer                                 # 作業結果データ
#  display_order   :integer          default(1), not null   # 表示順
#  hours           :decimal(3, 1)    default(0.0), not null # 稼動時間
#  fixed_quantity  :decimal(6, 2)                           # 確定稼動量
#  fixed_adjust_id :integer                                 # 確定稼動単位
#  fixed_price     :decimal(5, )                            # 確定稼動単価
#  fixed_amount    :decimal(7, )                            # 確定使用料
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class MachineResultTest < ActiveSupport::TestCase
  test "時間計算(期日後)" do
    machine_result = machine_results(:machine_result_march_hour)
    assert_equal machine_price_details(:machine_price_detail_march_hour).price, machine_result.price
    assert_equal machine_result.hours, machine_result.quantity
    assert_equal machine_result.hours * machine_price_details(:machine_price_detail_march_hour).price, machine_result.amount
  end
end
