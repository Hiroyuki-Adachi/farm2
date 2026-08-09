require "test_helper"

class LandCostTest < ActiveSupport::TestCase
  test "稲わら面積は対象期の期首日時点の土地原価で集計する" do
    system = systems(:s2015)
    land = lands(:land_land_cost1)
    straw_work = works(:works_land_total_query)
    straw_work_type = work_types(:work_types1)
    later_work_type = work_types(:work_types2)

    straw_work.update!(work_type: straw_work_type)
    LandCost.create!(land:, work_type: later_work_type, activated_on: Date.new(2015, 2, 1))

    result = LandCost.for_straws(system, straw_work_type.id)

    assert_equal land.area, result[land_costs(:cost1).work_type_id]
  end
end
