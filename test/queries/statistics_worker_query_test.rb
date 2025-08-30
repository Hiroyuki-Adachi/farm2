require "test_helper"

class StatisticsWorkerResultsTest < ActiveSupport::TestCase
  test "作業者別作業日数一覧クエリ" do
    results = StatisticsWorkerQuery.new(2019).call

    # 組合員と組合員外の両方が含まれることを確認
    assert_equal 3, results.size
    
    members = results.select { |r| r.member_flag }
    non_members = results.select { |r| !r.member_flag }
    
    assert_equal 2, members.size
    assert_equal 1, non_members.size

    work_result1 = work_results(:work_result_stat_2019_1_1)
    work_result2 = work_results(:work_result_stat_2019_2)
    machine_result = machine_results(:machine_result_stat_2019_1)

    # 組合員の結果確認
    member_result = members.first
    assert_equal work_result1.worker.home.name, member_result.home_name
    assert_equal work_result1.worker.family_name, member_result.family_name
    assert_equal work_result1.worker.first_name, member_result.first_name
    assert_equal 2, member_result.work_days
    assert_equal work_result1.hours + work_result2.hours, member_result.work_hours
    assert_equal 1, member_result.machine_days
    assert_equal machine_result.hours, member_result.machine_hours
    assert member_result.member_flag

    # 組合員外の結果確認
    non_member_result = non_members.first
    non_member_work_result = work_results(:work_result_stat_2019_non_member)
    assert_equal non_member_work_result.worker.home.name, non_member_result.home_name
    assert_equal non_member_work_result.worker.family_name, non_member_result.family_name
    assert_equal non_member_work_result.worker.first_name, non_member_result.first_name
    assert_equal 1, non_member_result.work_days
    assert_equal non_member_work_result.hours, non_member_result.work_hours
    assert_equal 0, non_member_result.machine_days
    assert_equal 0, non_member_result.machine_hours
    assert_not non_member_result.member_flag
  end
end
