require "test_helper"

class Tasks::StatusesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "ステータス編集" do
    get edit_task_status_path(@task, code: :doing)
    assert_response :success
    assert_select "form[action='#{task_status_path(@task, code: :doing)}']", true
  end

  test "ステータス編集(実行)" do
    patch task_status_path(@task, code: :doing),
          params: { task: { task_status: :doing, comment: "" } },
          headers: { "Accept" => "text/vnd.turbo-stream.html" }

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"
  end

  test "ステータス編集(実行エラー)" do
    # change_status! が例外を投げる状況をモック（mocha 利用）
    Task.any_instance.stubs(:change_status!).raises(ActiveRecord::RecordInvalid.new(@task))

    patch task_status_path(@task, code: :doing), params: {
      task: { task_status: :doing, comment: "" }
    }

    assert_response :unprocessable_entity
    # エラーフォームが返ってきていることの簡易確認
    assert_select "form[action='#{task_status_path(@task)}']", true
  end
end
