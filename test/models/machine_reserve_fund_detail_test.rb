require "test_helper"

class MachineReserveFundDetailTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @machine_reserve_fund = MachineReserveFund.create!(
      organization: @organization, machine: machines(:machines1),
      started_on: Date.new(2025, 4, 1), years: 7, total_amount: 1_000_000, remaining_amount: 1_000_000
    )
  end

  test "machine_reserve_fundと同じ組織なら登録できる" do
    detail = MachineReserveFundDetail.new(
      organization: @organization, machine_reserve_fund: @machine_reserve_fund,
      term: 2025, months: 12, amount: 100_000, remaining_amount: 900_000
    )
    assert detail.valid?
  end

  test "machine_reserve_fundと異なる組織では登録できない" do
    detail = MachineReserveFundDetail.new(
      organization: organizations(:org2), machine_reserve_fund: @machine_reserve_fund,
      term: 2025, months: 12, amount: 100_000, remaining_amount: 900_000
    )
    assert_not detail.valid?
    assert_includes detail.errors.attribute_names, :machine_reserve_fund_id
  end
end
