require "test_helper"

class MachineReserveFundCostTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    machine_reserve_fund = MachineReserveFund.create!(
      organization: @organization, machine: machines(:machines1),
      started_on: Date.new(2025, 4, 1), years: 7, total_amount: 1_000_000, remaining_amount: 1_000_000
    )
    @detail = MachineReserveFundDetail.create!(
      organization: @organization, machine_reserve_fund: machine_reserve_fund,
      term: 2025, months: 12, amount: 100_000, remaining_amount: 900_000
    )
  end

  test "machine_reserve_fund_detailと同じ組織なら登録できる" do
    cost = MachineReserveFundCost.new(
      organization: @organization, machine_reserve_fund_detail: @detail,
      work_type: work_types(:work_types1), cost: 50_000
    )
    assert cost.valid?
  end

  test "machine_reserve_fund_detailと異なる組織では登録できない" do
    cost = MachineReserveFundCost.new(
      organization: organizations(:org2), machine_reserve_fund_detail: @detail,
      work_type: work_types(:work_types1), cost: 50_000
    )
    assert_not cost.valid?
    assert_includes cost.errors.attribute_names, :machine_reserve_fund_detail_id
  end
end
