require "test_helper"

class Works::MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @work = works(:work_not_fixed)
    login_as(@user)
  end

  test "作業変更(機械)(表示)" do
    get new_work_machine_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(機械)(表示)(確定済)" do
    get new_work_machine_path(work_id: works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(機械)(変更)" do
    machine = machines(:machines1)
    work_result = work_results(:work_results_not_fixed)
    machine_hours = { machine.id => { work_result.id => 5 }}
    assert_difference('MachineResult.count') do
      post work_machines_path(work_id: @work), params: {
        machine_hours: machine_hours
      }
    end
    assert_redirected_to new_work_remark_path(work_id: works(:work_not_fixed))

    created_machine_result = MachineResult.last
    assert_equal work_result.id, created_machine_result.work_result_id
    assert_equal machine.id, created_machine_result.machine_id
    assert_equal machine_hours[machine.id][work_result.id], created_machine_result.hours
  end
end
