require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "タスク一覧" do
    get tasks_path
    assert_response :success
  end

  test "タスク一覧(権限なし)" do
    login_as(users(:user_user))
    get tasks_path
    assert_response :error
  end

  test "タスク作成" do
    get new_task_path
    assert_response :success
  end

  test "タスク作成(実行)" do
    assert_difference("Task.count") do
      post tasks_path, params: {
        task: {
          title: "新しいタスク",
          description: "説明です",
          priority: "low",
          office_role: "none",
          task_status_id: 0,
          assignee_id: @user.worker.id
        }
      }
    end
    assert_redirected_to tasks_path

    task = Task.order(:id).last
    assert_equal @user.worker.id, task.creator_id
    assert_equal task.created_at.to_date, task.planned_start_on
    assert task.task_watchers.exists?(worker_id: @user.worker.id)
    assert_equal 1, task.events.where(event_type: :task_created).count
    assert task.reads.exists?(worker_id: @user.worker.id)
  end

  test "タスク照会" do
    assert_difference("TaskRead.count", +1) do
      get task_url(@task)
    end
    assert_response :success
  end

  test "タスク削除" do
    # deletable? が true を返すことを仮定
    Task.any_instance.stubs(:deletable?).returns(true)

    assert_difference("Task.count", -1) do
      delete task_url(@task)
    end
    assert_redirected_to tasks_path
  end
end
