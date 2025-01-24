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
#  hours(稼動時間)                :decimal(3, 1)    default(0.0), not null
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

require 'test_helper'

class MachineResultTest < ActiveSupport::TestCase
  test "機械_期日後_時間" do
    machine_result = machine_results(:machine_result_march_hour)
    machine_price_detail = machine_price_details(:machine_price_detail_march_hour)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::HOUR, machine_result.adjust
    assert_equal machine_result.hours, machine_result.quantity
    assert_equal machine_result.hours * machine_price_detail.price, machine_result.amount
  end

  test "機械_期日後_面積" do
    machine_result = machine_results(:machine_result_march_area)
    land_area = work_lands(:work_land_march1).land.area + work_lands(:work_land_march2).land.area
    machine_price_detail = machine_price_details(:machine_price_detail_march_area)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::AREA, machine_result.adjust
    assert_equal land_area / 10, machine_result.quantity
    assert_equal land_area * machine_price_detail.price / 10, machine_result.amount
  end

  test "機械_期日後_日数" do
    machine_result = machine_results(:machine_result_march_day)
    machine_price_detail = machine_price_details(:machine_price_detail_march_day)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::DAY, machine_result.adjust
    assert_equal 1, machine_result.quantity
    assert_equal machine_price_detail.price, machine_result.amount
  end

  test "機械_期日前_時間" do
    machine_result = machine_results(:machine_result_feb_hour)
    machine_price_detail = machine_price_details(:machine_price_detail_1_hour)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::HOUR, machine_result.adjust
    assert_equal machine_result.hours, machine_result.quantity
    assert_equal machine_result.hours * machine_price_detail.price, machine_result.amount
  end

  test "機械_期日前_面積" do
    machine_result = machine_results(:machine_result_feb_area)
    land_area = work_lands(:work_land_feb1).land.area + work_lands(:work_land_feb2).land.area
    machine_price_detail = machine_price_details(:machine_price_detail_1_area)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::AREA, machine_result.adjust
    assert_equal land_area / 10, machine_result.quantity
    assert_equal land_area * machine_price_detail.price / 10, machine_result.amount
  end

  test "機械_期日前_日数" do
    machine_result = machine_results(:machine_result_feb_day)
    machine_price_detail = machine_price_details(:machine_price_detail_1_day)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::DAY, machine_result.adjust
    assert_equal 1, machine_result.quantity
    assert_equal machine_price_detail.price, machine_result.amount
  end

  test "機械種別_期日後_時間" do
    machine_result = machine_results(:machine_result_march_hour_t)
    machine_price_detail = machine_price_details(:machine_type_price_detail_march_hour)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::HOUR, machine_result.adjust
    assert_equal machine_result.hours, machine_result.quantity
    assert_equal machine_result.hours * machine_price_detail.price, machine_result.amount
  end

  test "機械種別_期日後_面積" do
    machine_result = machine_results(:machine_result_march_area_t)
    land_area = work_lands(:work_land_march1).land.area + work_lands(:work_land_march2).land.area
    machine_price_detail = machine_price_details(:machine_type_price_detail_march_area)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::AREA, machine_result.adjust
    assert_equal land_area / 10, machine_result.quantity
    assert_equal land_area * machine_price_detail.price / 10, machine_result.amount
  end

  test "機械種別_期日後_日数" do
    machine_result = machine_results(:machine_result_march_day_t)
    machine_price_detail = machine_price_details(:machine_type_price_detail_march_day)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::DAY, machine_result.adjust
    assert_equal 1, machine_result.quantity
    assert_equal machine_price_detail.price, machine_result.amount
  end

  test "機械種別_期日前_時間" do
    machine_result = machine_results(:machine_result_feb_hour_t)
    machine_price_detail = machine_price_details(:machine_type_price_detail_1_hour)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::HOUR, machine_result.adjust
    assert_equal machine_result.hours, machine_result.quantity
    assert_equal machine_result.hours * machine_price_detail.price, machine_result.amount
  end

  test "機械種別_期日前_面積" do
    machine_result = machine_results(:machine_result_feb_area_t)
    land_area = work_lands(:work_land_feb1).land.area + work_lands(:work_land_feb2).land.area
    machine_price_detail = machine_price_details(:machine_type_price_detail_1_area)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::AREA, machine_result.adjust
    assert_equal land_area / 10, machine_result.quantity
    assert_equal land_area * machine_price_detail.price / 10, machine_result.amount
  end

  test "機械種別_期日前_日数" do
    machine_result = machine_results(:machine_result_feb_day_t)
    machine_price_detail = machine_price_details(:machine_type_price_detail_1_day)
    assert_equal machine_price_detail.price, machine_result.price
    assert_equal Adjust::DAY, machine_result.adjust
    assert_equal 1, machine_result.quantity
    assert_equal machine_price_detail.price, machine_result.amount
  end
end
