require "test_helper"

class Tasks::CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "コメント追加" do
    assert_difference("TaskEvent.count", 1) do
      assert_difference("TaskComment.count", 1) do
        post task_comments_path(@task), params: { task_comment: { body: "新しいコメント" } }, xhr: true
      end
    end
    assert_response :success
    assert_includes response.body, "<turbo-stream"
  end
end
