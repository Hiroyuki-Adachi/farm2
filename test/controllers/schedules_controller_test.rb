require 'test_helper'

class SchedulesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @update = { worked_at: "2015-05-06", work_type_id: work_types(:work_type_koshi).id,
                start_at: "08:00:00", end_at: "17:00:00",
                work_kind_id: work_kinds(:work_kind_taue).id, name: "テスト", term: 2015 }
  end

  test "作業予定一覧" do
    get :index
    assert_response :success
  end

  test "作業予定登録(表示)" do
    get :new
    assert_response :success
  end

  test "作業予定登録(利用者)" do
    session[:user_id] = users(:user_user).id
    get :new
    assert_response :error
  end

  test "作業予定登録(実行)" do
    assert_difference('Schedule.count') do
      post :create, schedule: @update
    end
    assert_redirected_to new_schedule_worker_path(schedule_id: Schedule.maximum(:id))
  end

  test "作業予定変更(表示)" do
    get :edit, id: schedules(:schedule1)
    assert_response :success
  end

  test "作業予定変更(実行)" do
    get :update, id: schedules(:schedule1), schedule: @update
    assert_redirected_to schedules_path
    assert_equal Schedule.find(schedules(:schedule1).id).name, @update[:name]
  end

  test "作業予定削除" do
    assert_difference('Schedule.count', -1) do
      delete :destroy, id: schedules(:schedule1)
    end
    assert_redirected_to schedules_path
  end
end
