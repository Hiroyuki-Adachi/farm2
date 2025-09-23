require "test_helper"

class Tasks::OfficeRolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:open_task)
  end

  test "部門区分編集" do
    get edit_task_office_role_path(@task)
    assert_response :success
    assert_select "form[action='#{task_office_role_path(@task)}']", true
  end

  test "部門区分編集(実行)" do
    @task.update!(office_role: :finance)

    assert_no_difference "TaskEvent.count" do
      assert_no_difference "Task.count" do
        patch task_office_role_path(@task),
              params: { task: { office_role: :general } },
              headers: { "Accept" => "text/vnd.turbo-stream.html" }
      end
    end
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, "<turbo-stream"

    @task.reload
    assert_equal :general, @task.office_role.to_sym
  end
end
