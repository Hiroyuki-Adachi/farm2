require "test_helper"

class StatisticsWorkerResultsTest < ActiveSupport::TestCase
  test "作業者別作業日数一覧クエリ" do
    results = StatisticsWorkerQuery.new(2019, organization: organizations(:org)).call

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

  test "他組織の作業者と作業実績を集計しない" do
    results = StatisticsWorkerQuery.new(2015, organization: organizations(:org)).call

    assert_not(results.any? { |result| result.family_name == workers(:worker_other_org).family_name })
  end

  test "自家用車のみの作業は作業実績を残しオペレータ実績をゼロにする" do
    machine_results(:machine_result_stat_2019_1).update!(machine: machines(:machines9))

    result = StatisticsWorkerQuery.new(2019, organization: organizations(:org)).call.first

    assert_equal 2, result.work_days
    assert_equal work_results(:work_result_stat_2019_1_1).hours + work_results(:work_result_stat_2019_2).hours, result.work_hours
    assert_equal 0, result.machine_days
    assert_equal 0, result.machine_hours
  end

  test "組合所有機械と自家用車が混在しても組合所有分のみオペレータ実績に含める" do
    machine_result = machine_results(:machine_result_stat_2019_1)
    private_result = machine_result.dup
    private_result.machine = machines(:machines9)
    private_result.hours = 3
    private_result.save!

    result = StatisticsWorkerQuery.new(2019, organization: organizations(:org)).call.first

    assert_equal 2, result.work_days
    assert_equal work_results(:work_result_stat_2019_1_1).hours + work_results(:work_result_stat_2019_2).hours, result.work_hours
    assert_equal 1, result.machine_days
    assert_equal machine_result.hours, result.machine_hours
  end

  test "削除済みの組合所有機械と所有世帯も過去のオペレータ実績に含める" do
    machine_result = machine_results(:machine_result_stat_2019_1)
    machine_result.machine.update!(deleted_at: Time.current)
    machine_result.machine.owner.update!(deleted_at: Time.current)

    result = StatisticsWorkerQuery.new(2019, organization: organizations(:org)).call.first

    assert_equal 1, result.machine_days
    assert_equal machine_result.hours, result.machine_hours
  end
  test "同じ作業実績で組合所有機械を複数使っても作業時間を重複加算しない" do
    machine_result = machine_results(:machine_result_stat_2019_1)
    second_result = machine_result.dup
    second_result.machine = machines(:machines2)
    second_result.hours = 3
    second_result.save!

    results = StatisticsWorkerQuery.new(2019, organization: organizations(:org)).call

    result = results.first
    assert_equal 2, result.work_days
    assert_equal work_results(:work_result_stat_2019_1_1).hours + work_results(:work_result_stat_2019_2).hours, result.work_hours
    assert_equal 2, result.machine_days
    assert_equal machine_result.hours + second_result.hours, result.machine_hours

    without_machine = results.second
    assert_equal 1, without_machine.work_days
    assert_equal work_results(:work_result_stat_2019_1_2).hours, without_machine.work_hours
    assert_equal 0, without_machine.machine_days
    assert_equal 0, without_machine.machine_hours
  end
end
