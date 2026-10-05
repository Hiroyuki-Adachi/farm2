require "test_helper"

class MachineReserveFundCostEditingTest < ActiveSupport::TestCase
  setup do
    @system = systems(:s2015)
    @fund = MachineReserveFund.create!(organization: organizations(:org), machine: machines(:machines1),
                                       started_on: Date.new(2015, 1, 1), years: 1,
                                       total_amount: 120_000, remaining_amount: 120_000)
    @types = [work_types(:work_types1), work_types(:work_types2)]
    @types.each { |type| WorkTypeTerm.find_or_create_by!(work_type: type, term: 2015) }
    LandCost.stubs(:sum_areas_by_work_type).returns(@types.to_h { |type| [type.id, 1.to_d] })
    @detail = @fund.build_detail(@system)
    @detail.amount = 101
    assert @detail.register(@system)
    @values = WorkType.land.by_term(2015).to_h { |type| [type.id.to_s, "0"] }
    @values[@types.first.id.to_s] = "101"
  end

  test "原価をまとめて保存しても明細原価額と残額を変えない" do
    assert @detail.update_costs(@values), @detail.errors.full_messages.join
    assert_equal 101, @detail.machine_reserve_fund_costs.sum(:cost)
    assert_equal 101, @detail.machine_reserve_fund_costs.find_by!(work_type: @types.first).cost
    assert_equal 101, @detail.reload.amount
    assert_equal 119_899, @detail.remaining_amount
    assert_equal 119_899, @fund.reload.current_remaining_amount
  end

  test "合計不一致と非整数は全行の保存を拒否する" do
    before = @detail.machine_reserve_fund_costs.order(:id).pluck(:cost)
    @values[@types.first.id.to_s] = "100"
    assert_not @detail.update_costs(@values)
    assert_includes @detail.errors.full_messages.join, "合計は原価額と一致"
    assert_equal before, @detail.machine_reserve_fund_costs.reload.order(:id).pluck(:cost)
    @detail.reload
    @values[@types.first.id.to_s] = "100.5"
    @values[@types.last.id.to_s] = "0.5"
    assert_not @detail.update_costs(@values)
    assert_equal before, @detail.machine_reserve_fund_costs.reload.order(:id).pluck(:cost)
  end

  test "再按分は行を重複させず端数を調整し面積0なら以前の原価を保持する" do
    assert @detail.update_costs(@values)
    count = @detail.machine_reserve_fund_costs.count
    assert @detail.reallocate_costs(@system), @detail.errors.full_messages.join
    assert_equal count, @detail.machine_reserve_fund_costs.count
    assert_equal [50, 51], @detail.machine_reserve_fund_costs.where(work_type: @types).pluck(:cost).sort
    assert_equal 101, @detail.machine_reserve_fund_costs.sum(:cost)
    before = @detail.machine_reserve_fund_costs.order(:id).pluck(:cost)
    LandCost.stubs(:sum_areas_by_work_type).returns({})
    assert_not @detail.reallocate_costs(@system)
    assert_includes @detail.errors.full_messages.join, "圃場面積が0"
    assert_equal before, @detail.machine_reserve_fund_costs.reload.order(:id).pluck(:cost)
  end

  test "再按分は年度と組織が異なるSystemを拒否する" do
    assert_not @detail.reallocate_costs(systems(:s2016))
    assert_not @detail.reallocate_costs(systems(:s2015_org2))
  end

  test "当期分類の変更は保存成功時だけ原価行に反映する" do
    WorkTypeTerm.find_by!(work_type: @types.last, term: 2015).destroy!
    added = work_types(:work_type_mugi)
    WorkTypeTerm.find_or_create_by!(work_type: added, term: 2015)
    values = WorkType.land.by_term(2015).to_h { |type| [type.id.to_s, "0"] }
    values[@types.first.id.to_s] = "100"
    assert_not @detail.update_costs(values)
    assert @detail.machine_reserve_fund_costs.reload.exists?(work_type: @types.last)
    values[@types.first.id.to_s] = "101"
    assert @detail.reload.update_costs(values), @detail.errors.full_messages.join
    assert_not @detail.machine_reserve_fund_costs.exists?(work_type: @types.last)
    assert @detail.machine_reserve_fund_costs.exists?(work_type: added, cost: 0)
  end
end
