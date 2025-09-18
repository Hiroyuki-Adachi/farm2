require "test_helper"

class Tasks::WatchersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "監視者追加" do
    task = tasks(:open_task)
    assert_difference "TaskWatcher.count", 1 do
      post task_watchers_path(task_id: task.id),
            headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :success

    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"

    task_watcher = TaskWatcher.last
    assert_equal task.id, task_watcher.task_id
    assert_equal @user.worker_id, task_watcher.worker_id
  end

  test "監視者削除" do
    task = tasks(:worker1_task)

    assert_difference "TaskWatcher.count", -1 do
      delete task_watcher_path(task_id: task.id, id: @user.worker_id),
             headers: { "Accept" => "text/vnd.turbo-stream.html" }
    end
    assert_response :success

    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"

    assert_nil TaskWatcher.find_by(task_id: task.id, worker_id: @user.worker_id)
  end
end
