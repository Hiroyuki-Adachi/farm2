require "test_helper"

# == Schema Information
#
# Table name: machine_reserve_fund_costs(基盤強化準備金原価(作業分類別))
#
#  id                                                     :bigint           not null, primary key
#  cost(原価)                                             :decimal(9, )     not null
#  created_at                                             :datetime         not null
#  updated_at                                             :datetime         not null
#  machine_reserve_fund_detail_id(基盤強化準備金原価明細) :bigint           not null
#  organization_id(組織)                                  :bigint           not null
#  work_type_id(作業分類)                                 :integer          not null
#
# Indexes
#
#  idx_on_machine_reserve_fund_detail_id_2e7d1eb058     (machine_reserve_fund_detail_id)
#  idx_reserve_fund_costs_on_detail_and_work_type       (machine_reserve_fund_detail_id,work_type_id) UNIQUE
#  index_machine_reserve_fund_costs_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (machine_reserve_fund_detail_id => machine_reserve_fund_details.id)
#  fk_rails_...  (organization_id => organizations.id)
#
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
