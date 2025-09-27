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
end
