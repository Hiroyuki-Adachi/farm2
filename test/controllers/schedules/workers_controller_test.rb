require 'test_helper'

class Schedules::WorkersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:user_checker))
    @schedule = schedules(:schedule1)
    @update = { worked_at: "2015-05-07", work_type_id: work_types(:work_types23).id,
                start_at: "08:00:00", end_at: "17:00:00",
                work_kind_id: work_kinds(:work_kind_taue).id, name: "テスト2", term: 2015 }
  end

  test "作業予定者登録(表示)" do
    get new_schedule_worker_path(schedule_id: @schedule.id)
    assert_response :success
  end

  test "作業予定者登録(表示)(戻り先を保持)" do
    get new_schedule_worker_path(schedule_id: @schedule.id, return_to: schedules_path(page: 2))
    assert_response :success
    assert_select "input[name=return_to][value='#{schedules_path(page: 2)}']"
    assert_includes @response.body, %(href="#{schedules_path(page: 2)}")
  end

  test "作業予定者登録(閲覧者はNG)" do
    login_as(users(:user_visitor))
    get new_schedule_worker_path(schedule_id: @schedule.id)
    assert_response :error
  end

  test "作業予定登録(実行)" do
    schedule = Schedule.create(@update)
    schedule_worker = { worker_id: workers(:worker3).id, display_order: 3 }
    assert_difference('ScheduleWorker.count') do
      post schedule_workers_path(schedule_id: schedule.id), params: { schedule_workers: [schedule_worker] }
    end
    assert_redirected_to schedules_path

    created_schedule_worker = ScheduleWorker.last
    assert_equal schedule.id, created_schedule_worker.schedule_id
    assert_equal schedule_worker[:worker_id], created_schedule_worker.worker_id
    assert_equal schedule_worker[:display_order], created_schedule_worker.display_order
  end

  test "作業予定登録(実行)(戻り先を保持)" do
    schedule = Schedule.create(@update)
    schedule_worker = { worker_id: workers(:worker3).id, display_order: 3 }
    assert_difference('ScheduleWorker.count') do
      post schedule_workers_path(schedule_id: schedule.id), params: { schedule_workers: [schedule_worker], return_to: schedules_path(page: 2) }
    end
    assert_redirected_to schedules_path(page: 2)
  end
end
