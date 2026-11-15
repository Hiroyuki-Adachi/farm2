# == Schema Information
#
# Table name: machine_results(機械稼動データ)
#
#  id(機械稼動データ)             :integer          not null, primary key
#  display_order(表示順)          :integer          default(1), not null
#  fixed_amount(確定使用料)       :decimal(7, )
#  fixed_price(確定稼動単価)      :decimal(5, )
#  fixed_quantity(確定稼動量)     :decimal(6, 2)
#  fuel_usage(燃料使用量)         :decimal(5, 2)    default(0.0), not null
#  hours(稼動時間)                :decimal(4, 2)    default(0.0), not null
#  input_amount(直接入力使用料)   :decimal(7, )
#  created_at                     :datetime
#  updated_at                     :datetime
#  fixed_adjust_id(確定稼動単位)  :integer
#  machine_id(機械)               :integer
#  work_result_id(作業結果データ) :integer
#
# Indexes
#
#  index_machine_results_on_machine_id_and_work_result_id  (machine_id,work_result_id) UNIQUE
#
FactoryBot.define do
  factory :machine_result do
    work_result
    machine
    hours { 1 }
    display_order { 1 }
  end
end
