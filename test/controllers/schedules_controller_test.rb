require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:user_manager))
    @schedule = schedules(:schedule1)
    @update = { worked_at: "2015-05-06", work_type_id: work_types(:work_type_koshi).id,
                start_at: "08:00:00", end_at: "17:00:00",
                work_kind_id: work_kinds(:work_kind_taue).id, name: "テスト", term: 2015 }
  end

  test "作業予定一覧" do
    get schedules_path
    assert_response :success
  end

  test "作業予定一覧(閲覧者でも可)" do
    login_as(users(:user_visitor))
    get schedules_path
    assert_response :success
  end

  test "作業予定登録(表示)" do
    get new_schedule_path
    assert_response :success
  end

  test "作業予定登録(検閲者)" do
    login_as(users(:user_checker))
    get new_schedule_path
    assert_response :error
  end

  test "作業予定登録(実行)" do
    assert_difference('Schedule.count') do
      post schedules_path, params: {schedule: @update}
    end
    assert_redirected_to new_schedule_worker_path(schedule_id: Schedule.maximum(:id))

    # 作成した作業予定を検証
    schedule = Schedule.last
    assert_equal @update[:worked_at], schedule.worked_at.to_s
    assert_equal @update[:work_type_id], schedule.work_type_id
    assert_equal @update[:start_at], schedule.start_at.strftime("%H:%M:%S")
    assert_equal @update[:end_at], schedule.end_at.strftime("%H:%M:%S")
    assert_equal @update[:work_kind_id], schedule.work_kind_id
    assert_equal @update[:name], schedule.name
  end

  test "作業予定変更(表示)" do
    get edit_schedule_path(@schedule)
    assert_response :success
  end

  test "作業予定変更(実行)" do
    assert_no_difference('Schedule.count') do
      patch schedule_path(@schedule), params: {schedule: @update}
    end
    assert_redirected_to schedules_path

    # 更新した作業予定を検証
    @schedule.reload
    assert_equal @update[:worked_at], @schedule.worked_at.to_s
    assert_equal @update[:work_type_id], @schedule.work_type_id
    assert_equal @update[:start_at], @schedule.start_at.strftime("%H:%M:%S")
    assert_equal @update[:end_at], @schedule.end_at.strftime("%H:%M:%S")
    assert_equal @update[:work_kind_id], @schedule.work_kind_id
    assert_equal @update[:name], @schedule.name
  end

  test "作業予定削除" do
    assert_difference('Schedule.count', -1) do
      delete schedule_path(@schedule)
    end
    assert_redirected_to schedules_path

    assert_nil Schedule.find_by(id: @schedule)
  end
end
