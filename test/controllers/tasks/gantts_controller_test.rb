require "test_helper"

class Tasks::GanttsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
    @task.update!(planned_start_on: Date.new(2025, 1, 1), due_on: Date.new(2025, 1, 10))
  end

  test "ガント一覧" do
    get tasks_gantts_path
    assert_response :success
  end

  test "ガント一覧(権限なし)" do
    login_as(users(:user_user))
    get tasks_gantts_path
    assert_response :error
  end

  test "ガント更新(終了日の更新)" do
    assert_equal Date.new(2025, 1, 10), @task.due_on

    patch tasks_gantts_path,
          params: {
            task_id: @task.id,
            date: "2025-01-15",
            edge: "end"
          },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success

    @task.reload
    assert_equal Date.new(2025, 1, 15), @task.due_on
    assert_equal Date.new(2025, 1, 1), @task.planned_start_on
  end

  test "ガント更新(開始日の更新)" do
    assert_equal Date.new(2025, 1, 1), @task.planned_start_on

    patch tasks_gantts_path,
          params: {
            task_id: @task.id,
            date: "2024-12-28",
            edge: "start"
          },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success

    @task.reload
    assert_equal Date.new(2024, 12, 28), @task.planned_start_on
    assert_equal Date.new(2025, 1, 10), @task.due_on
  end

  test "ガント更新(不明なタスクで404を返す)" do
    patch tasks_gantts_path,
          params: {
            task_id: 999_999,
            date: "2025-01-15",
            edge: "end"
          },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :not_found
  end

  test "ガント更新(不正な日付で422を返す)" do
    patch tasks_gantts_path,
          params: {
            task_id: @task.id,
            date: "invalid-date",
            edge: "end"
          },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :unprocessable_entity
  end
end
