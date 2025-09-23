require "test_helper"

class Tasks::TitlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "タスク名編集" do
    get edit_task_title_path(@task)
    assert_response :success
    assert_select "form[action='#{task_title_path(@task)}']", true
  end

  test "タスク名編集(実行)" do
    title = "New Title"
    @task.update!(title: "Old Title")

    assert_no_difference "TaskEvent.count" do
      assert_no_difference "Task.count" do
        patch task_title_path(@task),
              params: { task: { title: title } },
              headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"

    @task.reload
    assert_equal title, @task.title
  end
end
