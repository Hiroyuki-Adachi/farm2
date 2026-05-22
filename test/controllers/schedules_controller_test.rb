require 'test_helper'

class SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_user)
    login_as(@user)
    @schedule = schedules(:schedule1)
    @update = { worked_at: "2015-05-06", work_type_id: work_types(:work_types23).id,
                start_at: "08:00:00", end_at: "17:00:00",
                calendar_remove_flag: false,
                farming_flag: true,
                line_flag: false,
                minutes_flag: false,
                work_kind_id: work_kinds(:work_kind_taue).id, name: "テスト" }
  end

  test "作業予定一覧" do
    get schedules_path
    assert_response :success
  end

  test "作業予定一覧(閲覧者でも表示OK)" do
    login_as(users(:user_visitor))
    get schedules_path
    assert_response :success
  end

  test "作業予定登録(表示)" do
    get new_schedule_path
    assert_response :success
  end

  test "作業予定作業分類切替" do
    get work_types_schedules_path(format: :turbo_stream), params: { term: 2015 }
    assert_response :success
    assert_includes @response.body, "schedule_work_types"
    assert_includes @response.body, work_types(:work_types23).name
  end

  test "作業予定登録は作業予定日の年度で有効な作業分類のみ許可" do
    invalid_update = @update.merge(work_type_id: work_types(:work_type_koshi).id)

    assert_no_difference('Schedule.count') do
      post schedules_path, params: { schedule: invalid_update }
    end
    assert_response :unprocessable_content
  end

  test "作業予定登録(実行)" do
    assert_difference('Schedule.count') do
      post schedules_path, params: { schedule: @update }
    end
    assert_redirected_to schedules_path

    # 作成した作業予定を検証
    schedule = Schedule.last
    assert_equal @update[:worked_at], schedule.worked_at.to_s
    assert_equal @update[:work_type_id], schedule.work_type_id
    assert_equal @update[:start_at], schedule.start_at.strftime("%H:%M:%S")
    assert_equal @update[:end_at], schedule.end_at.strftime("%H:%M:%S")
    assert_equal @update[:work_kind_id], schedule.work_kind_id
    assert_equal @update[:name], schedule.name
    assert_equal @update[:calendar_remove_flag], schedule.calendar_remove_flag
    assert_equal @update[:farming_flag], schedule.farming_flag
    assert_equal @update[:line_flag], schedule.line_flag
    assert_equal @update[:minutes_flag], schedule.minutes_flag
    assert_equal @user.worker.id, schedule.created_by
  end

  test "作業予定変更(表示)" do
    get edit_schedule_path(@schedule)
    assert_response :success
  end

  test "作業予定変更(表示)(戻り先を保持)" do
    get edit_schedule_path(@schedule, return_to: schedules_path(page: 2))
    assert_response :success
    assert_select "input[name=return_to][value='#{schedules_path(page: 2)}']"
    assert_includes @response.body, %(href="#{schedules_path(page: 2)}")
  end

  test "作業予定変更(表示)(本人不在の場合はNG)" do
    ScheduleWorker.where(schedule_id: @schedule.id, worker_id: @user.worker.id).destroy_all
    get edit_schedule_path(@schedule)
    assert_response :error
  end

  test "作業予定変更(表示)(本人不在でも作成者の場合はOK)" do
    ScheduleWorker.where(schedule_id: @schedule.id, worker_id: @user.worker.id).destroy_all
    @schedule.update_column(:created_by, @user.worker.id)
    get edit_schedule_path(@schedule)
    assert_response :success
  end

  test "作業予定変更(実行)" do
    assert_no_difference('Schedule.count') do
      patch schedule_path(@schedule), params: { schedule: @update }
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
    assert_equal @update[:calendar_remove_flag], @schedule.calendar_remove_flag
    assert_equal @update[:farming_flag], @schedule.farming_flag
    assert_equal @update[:line_flag], @schedule.line_flag
    assert_equal @update[:minutes_flag], @schedule.minutes_flag
  end

  test "作業予定変更(実行)(戻り先を保持)" do
    assert_no_difference('Schedule.count') do
      patch schedule_path(@schedule), params: { schedule: @update, return_to: schedules_path(page: 2) }
    end
    assert_redirected_to schedules_path(page: 2)
  end

  test "作業予定削除" do
    assert_difference('Schedule.count', -1) do
      delete schedule_path(@schedule)
    end
    assert_redirected_to schedules_path

    assert_nil Schedule.find_by(id: @schedule)
  end

  test "作業予定削除(戻り先を保持)" do
    assert_difference('Schedule.count', -1) do
      delete schedule_path(@schedule), params: { return_to: schedules_path(page: 2) }
    end
    assert_redirected_to schedules_path(page: 2)
  end
end
