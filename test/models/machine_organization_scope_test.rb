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

  test "減価償却と分類を所有世帯の組織で絞り込む" do
    depreciation = Depreciation.create!(machine: @other_machine, term: 2015, cost: 100)
    depreciation_type = DepreciationType.create!(depreciation: depreciation, work_type: work_types(:work_types1))
    assert_not_includes Depreciation.for_organization(@organization), depreciation
    assert_includes Depreciation.for_organization(@other_organization), depreciation
    assert_not_includes DepreciationType.for_organization(@organization), depreciation_type
    assert_includes DepreciationType.for_organization(@other_organization), depreciation_type
  end
end
