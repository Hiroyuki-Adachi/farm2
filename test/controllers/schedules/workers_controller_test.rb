require 'test_helper'

class Schedules::WorkersControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @update = { worked_at: "2015-05-07", work_type_id: work_types(:work_type_koshi).id,
      work_kind_id: work_kinds(:work_kind_taue).id, name: "テスト2", term: 2015 }
  end

  test "作業予定者登録(表示)" do
    get :new, schedule_id: 1
    assert_response :success
  end

  test "作業予定登録(実行)" do
    schedule = Schedule.create(@update)
    assert_difference('ScheduleWorker.count') do
      get :create, schedule_id: schedule, schedule_workers: [worker_id: 3, display_order: 3]
    end
    assert_redirected_to schedules_path
  end
end
