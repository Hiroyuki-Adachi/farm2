require "test_helper"

class LandTotalQueryTest < ActiveSupport::TestCase
  test "作業種別土地別作業日数一覧クエリ" do
    work_kinds = [work_kinds(:work_kind_taue).id, work_kinds(:work_kind_shirokaki).id]
    work = works(:works_land_total_query)
    work_land = work_lands(:work_land_land_total_query)
    results = LandTotalQuery.new(work_kinds, systems(:s2015)).call
    result = results.find {|result| result.place == work_land.land.place}

    assert_not_nil result
    assert_equal work.worked_at, result.w_date[work_kinds(:work_kind_shirokaki).id]
    assert_nil result.w_date[work_kinds(:work_kind_taue).id]
    assert_equal land_costs(:cost1).work_type.name, result.work_type_name
    assert_equal work_land.land.parcel_number, result.parcel_number
    assert_equal work_land.land.area, result.area
    assert_equal work_land.land.owner.name, result.owner_name
  end
end
