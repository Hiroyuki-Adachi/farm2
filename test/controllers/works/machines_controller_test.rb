require "test_helper"

class Works::MachinesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
  end

  test "作業変更(機械)(表示)" do
    get :new, params: {work_id: works(:work_not_fixed)}
    assert_response :success

    get :new, params: {work_id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(機械)(変更)" do
    work_result = work_results(:work_results_not_fixed)
    assert_difference('MachineResult.count') do
      post :create, params: {
        work_id: works(:work_not_fixed),
        machine_hours: { 4 => { work_result.id => 5 }}
      }
    end
    assert_redirected_to new_work_remark_path(work_id: works(:work_not_fixed))

    updated_machine_result = MachineResult.find_by(work_result_id: work_result, machine_id: 4)
    assert_not_nil updated_machine_result
    assert_equal 5, updated_machine_result.hours
    assert_equal 4, updated_machine_result.machine_id
  end
end
