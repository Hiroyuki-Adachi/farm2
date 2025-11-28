require "test_helper"

class Tasks::KanbansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "カンバン一覧" do
    get tasks_kanbans_path
    assert_response :success
  end

  test "カンバン一覧(権限なし)" do
    login_as(users(:user_user))
    get tasks_kanbans_path
    assert_response :error
  end

  test "カンバン移動(縦移動)" do
    task1 = tasks(:open_task)
    task2 = tasks(:worker1_task)
    payload = {
      columns: [
        {
          task_kanban_column: TaskStatus::TO_DO.kanban_column,
          task_ids: [task2.id, task1.id]
        }
      ]
    }

    patch tasks_kanbans_path, params: payload.to_json,
                              headers: {
                                "CONTENT_TYPE" => "application/json"
                              }

    assert_response :success

    task1.reload
    task2.reload

    # 並び順だけ変わって、ステータスは変わってない想定
    assert_equal 1, task1.kanban_position
    assert_equal 0, task2.kanban_position

    assert_equal TaskStatus::TO_DO.id, task1.task_status_id
    assert_equal TaskStatus::TO_DO.id, task2.task_status_id
  end

  test "カンバン移動(列移動)" do
    task1 = tasks(:open_task)
    task2 = tasks(:started_task)
    payload = {
      columns: [
        {
          task_kanban_column: TaskStatus::DOING.kanban_column,
          task_ids: [task2.id, task1.id]
        }
      ]
    }

    patch tasks_kanbans_path, params: payload.to_json,
                              headers: {
                                "CONTENT_TYPE" => "application/json"
                              }

    assert_response :success

    task1.reload
    task2.reload

    # 並び順とステータスの両方が変わる想定
    assert_equal 1, task1.kanban_position
    assert_equal 0, task2.kanban_position

    assert_equal TaskStatus::DOING.id, task1.task_status_id
    assert_equal TaskStatus::DOING.id, task2.task_status_id
  end
end
