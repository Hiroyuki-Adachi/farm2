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
  include MachinePricingScenario

  test "機械_期日後_時間" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::HOUR,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    assert_equal 2100, result.price
    assert_equal Adjust::HOUR, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 2100, result.amount
  end

  test "機械_期日後_面積" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::AREA,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    assert_equal 2200, result.price
    assert_equal Adjust::AREA, result.adjust
    assert_equal BigDecimal("3.625"), result.quantity
    assert_equal BigDecimal("3.625") * 2200, result.amount
  end

  test "機械_期日後_日数" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::DAY,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    assert_equal 2300, result.price
    assert_equal Adjust::DAY, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 2300, result.amount
  end

  test "機械_期日前_時間" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::HOUR,
                                            worked_at: Date.new(2015, 2, 28), same_home: true)
    assert_equal 1100, result.price
    assert_equal Adjust::HOUR, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 1100, result.amount
  end

  test "機械_期日前_面積" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::AREA,
                                            worked_at: Date.new(2015, 2, 28), same_home: true)
    assert_equal 1200, result.price
    assert_equal Adjust::AREA, result.adjust
    assert_equal BigDecimal("3.625"), result.quantity
    assert_equal BigDecimal("3.625") * 1200, result.amount
  end

  test "機械_期日前_日数" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::DAY,
                                            worked_at: Date.new(2015, 2, 28), same_home: true)
    assert_equal 1300, result.price
    assert_equal Adjust::DAY, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 1300, result.amount
  end

  test "機械種別_期日後_時間" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::HOUR,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    assert_equal 4100, result.price
    assert_equal Adjust::HOUR, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 4100, result.amount
  end

  test "機械種別_期日後_面積" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::AREA,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    assert_equal 4200, result.price
    assert_equal Adjust::AREA, result.adjust
    assert_equal BigDecimal("3.625"), result.quantity
    assert_equal BigDecimal("3.625") * 4200, result.amount
  end

  test "機械種別_期日後_日数" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::DAY,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    assert_equal 4300, result.price
    assert_equal Adjust::DAY, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 4300, result.amount
  end

  test "機械種別_期日前_時間" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::HOUR,
                                            worked_at: Date.new(2015, 2, 28), same_home: true)
    assert_equal 3100, result.price
    assert_equal Adjust::HOUR, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 3100, result.amount
  end

  test "機械種別_期日前_面積" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::AREA,
                                            worked_at: Date.new(2015, 2, 28), same_home: true)
    assert_equal 3200, result.price
    assert_equal Adjust::AREA, result.adjust
    assert_equal BigDecimal("3.625"), result.quantity
    assert_equal BigDecimal("3.625") * 3200, result.amount
  end

  test "機械種別_期日前_日数" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::DAY,
                                            worked_at: Date.new(2015, 2, 28), same_home: true)
    assert_equal 3300, result.price
    assert_equal Adjust::DAY, result.adjust
    assert_equal 1, result.quantity
    assert_equal 1 * 3300, result.amount
  end

  test "共有fixtureの所有者や作業者を変更しても専用の価格計算に影響しない" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::DAY,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    assert_equal 4300, result.price
    assert_equal 4300, result.amount

    shared_machine = machines(:machine_day_t)
    shared_worker = workers(:worker1)
    assert_not_equal shared_machine.id, result.machine_id
    assert_not_equal shared_worker.id, result.work_result.worker_id
    assert_not_equal shared_machine.owner.id, result.owner.id
    assert_not_equal shared_worker.home_id, result.work_result.worker.home_id

    shared_machine.update!(owner: homes(:home_kumiai))
    shared_worker.update!(home: homes(:home2))
    assert_equal homes(:home_kumiai).id, shared_machine.reload.owner.id
    assert_equal homes(:home2).id, shared_worker.reload.home_id

    # 計算値のインスタンス変数キャッシュを使わず、DBから新しいインスタンスを取得する。
    result = MachineResult.find(result.id)
    assert_equal 4300, result.price
    assert_equal Adjust::DAY, result.adjust
    assert_equal 1, result.quantity
    assert_equal 4300, result.amount
  end

  test "別世帯の作業者にはリース単価を使う" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::HOUR,
                                            worked_at: Date.new(2015, 3, 1), same_home: false)
    assert_equal 2600, result.price
    assert_equal 2600, result.amount
  end

  test "作業種別別単価を共通単価より優先する" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::DAY,
                                            worked_at: Date.new(2015, 3, 1), same_home: true,
                                            work_kind_specific: true)
    assert_equal 9000, result.price
    assert_equal 9000, result.amount
  end

  test "機械別単価を機種別単価より優先する" do
    result = build_machine_pricing_scenario(source: :machine_type, adjust: Adjust::DAY,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    header = FactoryBot.create(:machine_price_header, machine: result.machine,
                                                      validated_at: Date.new(2001, 1, 1))
    FactoryBot.create(:machine_price_detail, header: header, adjust_id: Adjust::DAY.id, price: 7000)
    assert_equal 7000, result.price
    assert_equal 7000, result.amount
  end

  test "時間単価の数量は同じ作業と機械の稼働時間を合計する" do
    result = build_machine_pricing_scenario(source: :machine, adjust: Adjust::HOUR,
                                            worked_at: Date.new(2015, 3, 1), same_home: true)
    worker = FactoryBot.create(:worker, home: result.owner, organization: result.work.organization)
    work_result = FactoryBot.create(:work_result, work: result.work, worker: worker)
    FactoryBot.create(:machine_result, machine: result.machine, work_result: work_result, hours: 2)
    assert_equal 3, result.quantity
    assert_equal 6300, result.amount
  end
end
