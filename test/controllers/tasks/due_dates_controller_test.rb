require "test_helper"

class Tasks::DueDatesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "期限編集" do
    get edit_task_due_on_path(@task)
    assert_response :success
    assert_select "form[action='#{task_due_on_path(@task)}']", true
  end

  test "期限編集(実行)" do
    assert_difference "TaskEvent.count", 1 do
      assert_no_difference "TaskComment.count" do
        assert_no_difference "Task.count" do
          patch task_due_on_path(@task),
                params: { task: { due_on: 1.day.from_now } },
                headers: { "Accept" => "text/vnd.turbo-stream.html" }
        end
      end
    end

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"
  end

  test "期限編集(実行エラー)" do
    # change_due_on! が例外を投げる状況をモック（mocha 利用）
    Task.any_instance.stubs(:change_due_on!).raises(ActiveRecord::RecordInvalid.new(@task))

    assert_no_difference "TaskEvent.count" do
      patch task_due_on_path(@task), params: {
        task: { due_on: 1.day.from_now }
      }
    end

    assert_response :unprocessable_entity
    # エラーフォームが返ってきていることの簡易確認
    assert_select "form[action='#{task_due_on_path(@task)}']", true
  end
end
