require "test_helper"

class Tasks::EndReasonsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:closed_task)
  end

  test "完了理由編集" do
    get edit_task_end_reason_path(@task)
    assert_response :success
    assert_select "form[action='#{task_end_reason_path(@task)}']", true
  end

  test "完了理由編集(実行)" do
    @task.update!(end_reason: :completed)

    assert_no_difference "TaskEvent.count" do
      assert_no_difference "Task.count" do
        patch task_end_reason_path(@task),
              params: { task: { end_reason: :no_action } },
              headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"

    @task.reload
    assert_equal :no_action, @task.end_reason.to_sym
  end
end
