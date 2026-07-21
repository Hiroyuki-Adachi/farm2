require "test_helper"

class LandDetailOrganizationScopeTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @other_organization = organizations(:org2)
    @other_land = lands(:land_other_org)
  end

  test "土地原価を親土地の組織で絞り込む" do
    land_cost = LandCost.create!(
      land: @other_land,
      work_type: work_types(:work_types1),
      activated_on: Date.new(2015, 1, 1)
    )

    assert_not_includes LandCost.for_organization(@organization), land_cost
    assert_includes LandCost.for_organization(@other_organization), land_cost
    assert_equal @other_land.area, LandCost.total(Date.new(2015, 1, 1), @other_organization)[land_cost.work_type_id]
    assert_equal @other_land.area,
                 LandCost.sum_area_by_work_type(Date.new(2015, 1, 1), land_cost.work_type_id, @other_organization)
  end

  test "土地料金を親土地の組織で絞り込む" do
    land_fee = LandFee.create!(land: @other_land, term: 2015, manage_fee: 100, peasant_fee: 200)

    assert_not_includes LandFee.for_organization(@organization), land_fee
    assert_includes LandFee.for_organization(@other_organization), land_fee
  end

  test "土地管理を親土地の組織で絞り込む" do
    land_home = LandHome.create!(
      land: @other_land,
      home: homes(:home_other_org),
      place: @other_land.place,
      area: @other_land.area,
      owner_flag: true
    )

    assert_not_includes LandHome.for_organization(@organization), land_home
    assert_includes LandHome.for_organization(@other_organization), land_home
  end

  test "土地年度別記号を親土地の組織で絞り込む" do
    land_term_mark = LandTermMark.create!(land: @other_land, term: 2015, mark: "Z")

    assert_not_includes LandTermMark.for_organization(@organization), land_term_mark
    assert_includes LandTermMark.for_organization(@other_organization), land_term_mark
  end

  test "集計原価明細を親集計原価の組織で絞り込む" do
    total_cost = TotalCost.create!(
      organization: @other_organization,
      term: 2015,
      occurred_on: Date.new(2015, 1, 1),
      total_cost_type_id: TotalCostType::LAND.id,
      amount: 100
    )
    detail = TotalCostDetail.create!(
      total_cost: total_cost,
      work_type: work_types(:work_types1),
      area: 10,
      cost: 100
    )

    assert_not_includes TotalCostDetail.for_organization(@organization), detail
    assert_includes TotalCostDetail.for_organization(@other_organization), detail
  end
end
