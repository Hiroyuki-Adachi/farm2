require 'test_helper'

class SeedlingResultTest < ActiveSupport::TestCase
  test "育苗使用画面順" do
    seedling_home = seedling_homes(:seedling_home1)

    same_work_first = SeedlingResult.create!(
      seedling_home: seedling_home,
      work_result: work_results(:work_result_taue1),
      display_order: 1,
      quantity: 10
    )
    earlier_work = SeedlingResult.create!(
      seedling_home: seedling_home,
      work_result: work_results(:work_results300),
      display_order: 99,
      quantity: 20
    )
    same_work_second = SeedlingResult.create!(
      seedling_home: seedling_home,
      work_result: work_results(:work_result_taue2),
      display_order: 0,
      quantity: 30
    )

    assert_equal(
      [earlier_work.id, same_work_first.id, same_work_second.id],
      seedling_home.seedling_results.for_seedling_use.limit(3).ids
    )
  end
end
