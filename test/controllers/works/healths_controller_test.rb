require "test_helper"

class Works::HealthsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @work = works(:work_not_fixed)
    login_as(@user)
  end

  test "作業変更(健康)(表示)" do
    get new_work_health_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(健康)(変更)" do
    result = work_results(:work_results_not_fixed)
    health = {health_id: 2, remarks: "TEST"}
    assert_no_difference('WorkResult.count') do
      post work_healths_path(work_id: @work.id), params: {results: {result.id => health}}
    end
    assert_redirected_to new_work_task_path(work_id: @work)

    result.reload
    assert_equal health[:health_id], result.health_id
    assert_equal health[:remarks], result.remarks
  end
end
