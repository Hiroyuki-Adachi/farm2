require "test_helper"

class LandTotalQueryTest < ActiveSupport::TestCase
  test "作業種別土地別作業日数一覧クエリ" do
    work_kinds = [work_kinds(:work_kind_taue).id, work_kinds(:work_kind_shirokaki).id]
    work = works(:works_land_total_query)
    work_land = work_lands(:work_land_land_total_query)
    results = LandTotalQuery.new(work_kinds, systems(:s2015)).call
    result = results.find { |result| result.place == work_land.land.place }

    assert_not_nil result
    assert_equal work.worked_at, result.w_date[work_kinds(:work_kind_shirokaki).id]
    assert_nil result.w_date[work_kinds(:work_kind_taue).id]
    assert_equal land_costs(:cost1).work_type.name, result.work_type_name
    assert_equal work_land.land.parcel_number, result.parcel_number
    assert_equal work_land.land.area, result.area
    assert_equal work_land.land.owner.name, result.owner_name
  end

  test "作業種別IDはSQL識別子に使う前に整数へ正規化する" do
    safe_id = work_kinds(:work_kind_shirokaki).id
    query = LandTotalQuery.new(["#{safe_id};DROP TABLE works", "0", "-1", safe_id.to_s], systems(:s2015))
    sql = query.send(:build_sql)

    assert_includes sql, %("W#{safe_id}")
    assert_not_includes sql, "DROP TABLE"
    assert_equal [safe_id], query.instance_variable_get(:@work_kind_ids)
  end

  test "有効な作業種別IDがない場合は空配列を返す" do
    assert_equal [], LandTotalQuery.new(["x", "0", "-1"], systems(:s2015)).call
  end
end
