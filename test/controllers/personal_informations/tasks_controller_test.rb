require "test_helper"

class PersonalInformations::TasksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @task = tasks(:open_task)
  end

  test "タスク照会" do
    get personal_information_task_path(@task, personal_information_token: @user.token)
    assert_response :success
  end
end
