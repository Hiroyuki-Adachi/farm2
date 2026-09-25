require "test_helper"

class MachineOrganizationScopeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
    @machine = machines(:machines1)
    @other_machine = machines(:machine_other_org)
  end

  test "機械を所有世帯の組織で絞り込む" do
    assert_includes Machine.for_organization(@organization), @machine
    assert_not_includes Machine.for_organization(@organization), @other_machine
    assert_includes Machine.for_organization(@other_organization), @other_machine
  end

  test "機械稼働実績を親作業の組織で絞り込む" do
    other_result = MachineResult.create!(machine: @other_machine, work_result: work_results(:work_result_other_org))
    assert_not_includes MachineResult.for_organization(@organization), other_result
    assert_includes MachineResult.for_organization(@other_organization), other_result
  end

  test "機械備考を親作業の組織で絞り込む" do
    remark = MachineRemark.create!(machine: @other_machine, work: works(:work_other_org), other_remarks: "別組織")
    assert_not_includes MachineRemark.for_organization(@organization), remark
    assert_includes MachineRemark.for_organization(@other_organization), remark
  end

  test "機械単価と明細を所有世帯の組織で絞り込む" do
    header = MachinePriceHeader.new(machine: @other_machine, machine_type_id: 0, validated_at: Date.new(2015, 1, 1))
    header.details_form = {}
    header.save!
    detail = MachinePriceDetail.create!(
      machine_price_header_id: header.id, work_kind_id: 0, lease_id: :normal, adjust_id: 1, price: 100
    )
    assert_not_includes MachinePriceHeader.for_organization(@organization), header
    assert_includes MachinePriceHeader.for_organization(@other_organization), header
    assert_not_includes MachinePriceDetail.for_organization(@organization), detail
    assert_includes MachinePriceDetail.for_organization(@other_organization), detail
  end

  test "基盤強化準備金原価を組織で絞り込む" do
    reserve_fund = MachineReserveFund.new(
      organization: @other_organization, machine: @other_machine,
      started_on: Date.new(2025, 4, 1), years: 7, total_amount: 1_000_000, remaining_amount: 1_000_000
    )
    # @other_machineは組合所有ではないため通常はvalidateで弾かれる。ここではfor_organizationスコープの
    # 検証が目的なのでバリデーションをスキップする。
    reserve_fund.save!(validate: false)
    assert_not_includes MachineReserveFund.for_organization(@organization), reserve_fund
    assert_includes MachineReserveFund.for_organization(@other_organization), reserve_fund
  end
end
