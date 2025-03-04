require "test_helper"

class StatisticsWorkerResultsTest < ActiveSupport::TestCase
  test "業者別作業日数一覧クエリ" do
    results = StatisticsWorkerQuery.new(2019).call

    assert_equal 2, results.size

    work_result1 = work_results(:work_result_stat_2019_1_1)
    work_result2 = work_results(:work_result_stat_2019_2)
    machine_result = machine_results(:machine_result_stat_2019_1)

    result = results.first
    assert_equal work_result1.worker.home.name, result.home_name
    assert_equal work_result1.worker.family_name, result.family_name
    assert_equal work_result1.worker.first_name, result.first_name
    assert_equal 2, result.work_days
    assert_equal work_result1.hours + work_result2.hours, result.work_hours
    assert_equal 1, result.machine_days
    assert_equal machine_result.hours, result.machine_hours
  end
end
