require "test_helper"

class Tasks::PrioritiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "優先度編集" do
    get edit_task_priority_path(@task)
    assert_response :success
    assert_select "form[action='#{task_priority_path(@task)}']", true
  end

  test "優先度編集(実行)" do
    @task.update!(priority: :low)

    assert_no_difference "TaskEvent.count" do
      assert_no_difference "Task.count" do
        patch task_priority_path(@task),
              params: { task: { priority: :high } },
              headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"

    @task.reload
    assert_equal :high, @task.priority.to_sym
  end
end
