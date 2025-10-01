require "test_helper"

class Works::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "作業変更(タスク)(表示)(タスクなし)" do
    work = works(:work_taue)
    get new_work_task_path(work_id: work)
    assert_redirected_to work_path(id: work)
  end  

  test "作業変更(タスク)(表示)(タスクあり)" do
    work = works(:work_task_work)
    get new_work_task_path(work_id: work)
    assert_response :success
  end

  test "作業変更(タスク)(更新)" do
    work = works(:work_task_work)
    task1 = tasks(:task31) 
    task3 = tasks(:task33) 
    assert_not work.tasks.include?(task1)
    assert_not work.tasks.include?(task3)

    post work_tasks_path(work_id: work), params: {
      check_task_ids: [task1.id, task3.id],
      close_task_ids: [task3.id]
    }
    assert_redirected_to work_path(id: work)
    assert work.tasks.include?(task1)
    assert work.tasks.include?(task3)
    assert_equal TaskStatus::DONE, task3.reload.status
  end
end
