require "test_helper"

class WorkTotalAgeQueryTest < ActiveSupport::TestCase
  test "年度別年齢別作業集計クエリ" do
    total_ages = WorkTotalAgeQuery.new.call

    total_hours = Work.joins(:work_results)
        .where(term: 2015, "work_results.worker_id" => workers(:worker1).id).sum("work_results.hours")
    assert_equal total_hours, total_ages[[2015, 0]]

    total_hours = Work.joins(:work_results)
        .where(term: 2015, "work_results.worker_id" => workers(:worker2).id).sum("work_results.hours")
    assert_equal total_hours, total_ages[[2015, 2]]

    total_hours = Work.joins(:work_results)
        .where(term: 2015, "work_results.worker_id" => workers(:worker3).id).sum("work_results.hours")
    assert_equal total_hours, total_ages[[2015, 5]]
  end
end
