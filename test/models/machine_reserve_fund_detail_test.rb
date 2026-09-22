require "test_helper"

# == Schema Information
#
# Table name: machine_reserve_fund_details(基盤強化準備金原価明細)
#
#  id                                          :bigint           not null, primary key
#  amount(原価額)                              :decimal(9, )     not null
#  months(按分月数)                            :integer          not null
#  remaining_amount(残額)                      :decimal(9, )     not null
#  term(年度(期))                              :integer          not null
#  created_at                                  :datetime         not null
#  updated_at                                  :datetime         not null
#  machine_reserve_fund_id(基盤強化準備金原価) :bigint           not null
#  organization_id(組織)                       :bigint           not null
#
# Indexes
#
#  idx_reserve_fund_details_on_fund_and_term                      (machine_reserve_fund_id,term) UNIQUE
#  index_machine_reserve_fund_details_on_machine_reserve_fund_id  (machine_reserve_fund_id)
#  index_machine_reserve_fund_details_on_organization_id          (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (machine_reserve_fund_id => machine_reserve_funds.id)
#  fk_rails_...  (organization_id => organizations.id)
#
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
