require "test_helper"

class Tasks::WorksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @task = tasks(:started_task)
    @work = works(:work_task_work)
  end

  test "作業一覧" do
    get task_works_path(@task)
    assert_response :success
    assert_select "turbo-frame#work_link_modal_frame"
  end

  test "作業紐づけ" do
    assert_not @task.events.exists?(work_id: @work.id)
    assert_difference "TaskEvent.count", 1 do
      patch task_work_url(@task, @work)
    end
    assert @task.reload.events.exists?(work_id: @work.id)
  end

  test "作業紐づけ解除" do
    @task.add_work!(actor: @user.worker, work: @work)
    assert @task.events.exists?(work_id: @work.id)

    assert_difference "TaskEvent.count", -1 do
      delete task_work_url(@task, @work)
    end
    assert_response :success
    assert_not @task.events.exists?(work_id: @work.id)
  end
end
