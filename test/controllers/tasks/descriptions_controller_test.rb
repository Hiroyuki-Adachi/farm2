require "test_helper"

class Tasks::DescriptionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "内容編集" do
    get edit_task_description_path(@task)
    assert_response :success
    assert_select "form[action='#{task_description_path(@task)}']", true
  end

  test "内容編集(実行)" do
    description = "New description"
    @task.update!(description: "Old description")

    assert_no_difference "TaskEvent.count" do
      assert_no_difference "Task.count" do
        patch task_description_path(@task),
              params: { task: { description: description } },
              headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"

    @task.reload
    assert_equal description, @task.description
  end
end
