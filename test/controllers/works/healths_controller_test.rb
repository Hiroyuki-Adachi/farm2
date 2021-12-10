require "test_helper"

class Works::HealthsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
    @work = works(:work_not_fixed)
  end

  test "作業変更(健康)(表示)" do
    get :new, params: {work_id: @work}
    assert_response :success
  end

  test "作業変更(健康)(変更)" do
    result = work_results(:work_results_not_fixed)
    health = {health_id: 2, remarks: "TEST"}
    assert_no_difference('WorkResult.count') do
      post :create, params: {work_id: @work.id, :results => {result.id => health}}
    end
    new_result = WorkResult.find(result.id)
    assert_equal health[:health_id], new_result.health_id
    assert_equal health[:remarks], new_result.remarks
    assert_redirected_to work_path(id: @work)
  end
end
