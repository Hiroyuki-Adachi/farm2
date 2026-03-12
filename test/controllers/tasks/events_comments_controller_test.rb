require "test_helper"

class Tasks::EventsCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_checker)
    login_as(@user)
    @event_no_comment = task_events(:due_on_event)
    @event_comment = task_events(:comment_event)
  end

  test "イベントコメント照会" do
    task = @event_no_comment.task
    get task_event_comment_path(task, @event_no_comment)
    assert_response :success
    assert_includes response.body, "<turbo-stream"
  end

  test "イベントコメント編集" do
    task = @event_no_comment.task
    get edit_task_event_comment_path(task, @event_no_comment)
    assert_response :success
    assert_includes response.body, "<turbo-stream"
  end

  test "イベントコメント追加" do
    task = @event_no_comment.task
    add_comment = "イベントコメント追加"
    assert_no_difference("TaskEvent.count") do
      assert_difference("TaskComment.count", 1) do
        post task_event_comment_path(task, @event_no_comment), params: { task_comment: { body: add_comment } }
      end
    end
    assert_response :success
    assert_includes response.body, "<turbo-stream"
    assert_includes response.body, add_comment
  end

  test "イベントコメント変更" do
    update_comment = "イベントコメント変更"
    task = @event_comment.task
    assert_no_difference("TaskEvent.count") do
      assert_no_difference("TaskComment.count") do
        patch task_event_comment_path(task, @event_comment), params: { task_comment: { body: update_comment } }
      end
    end
    assert_response :success
    assert_includes response.body, "<turbo-stream"
    assert_includes response.body, update_comment
  end

  test "イベントコメント削除" do
    task = @event_comment.task
    assert_no_difference("TaskEvent.count") do
      assert_difference("TaskComment.count", -1) do
        patch task_event_comment_path(task, @event_comment), params: { task_comment: { body: "" } }
      end
    end
    assert_response :success
  end
end
