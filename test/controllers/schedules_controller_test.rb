require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
    @update = { worked_at: "2015-05-06", work_type_id: work_types(:work_type_koshi).id,
                start_at: "08:00:00", end_at: "17:00:00",
                work_kind_id: work_kinds(:work_kind_taue).id, name: "テスト", term: 2015 }
  end

  test "作業予定一覧" do
    get :index
    assert_response :success
  end

  test "作業予定一覧(閲覧者でも可)" do
    session[:user_id] = users(:user_visitor).id
    get :index
    assert_response :success
  end

  test "作業予定登録(表示)" do
    get :new
    assert_response :success
  end

  test "作業予定登録(検閲者)" do
    session[:user_id] = users(:user_checker).id
    get :new
    assert_response :error
  end

  test "作業予定登録(実行)" do
    assert_difference('Schedule.count') do
      post :create, params: {schedule: @update}
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
    get :edit, params: {id: schedules(:schedule1)}
    assert_response :success
  end

  test "作業予定変更(実行)" do
    assert_no_difference('Schedule.count') do
      patch :update, params: {id: schedules(:schedule1), schedule: @update}
    end
    assert_redirected_to schedules_path

    # 更新した作業予定を検証
    schedule = Schedule.find(schedules(:schedule1).id)
    assert_not_nil schedule
    assert_equal @update[:worked_at], schedule.worked_at.to_s
    assert_equal @update[:work_type_id], schedule.work_type_id
    assert_equal @update[:start_at], schedule.start_at.strftime("%H:%M:%S")
    assert_equal @update[:end_at], schedule.end_at.strftime("%H:%M:%S")
    assert_equal @update[:work_kind_id], schedule.work_kind_id
    assert_equal @update[:name], schedule.name
  end

  test "作業予定削除" do
    assert_difference('Schedule.count', -1) do
      delete :destroy, params: {id: schedules(:schedule1)}
    end
    assert_redirected_to schedules_path
  end
end
