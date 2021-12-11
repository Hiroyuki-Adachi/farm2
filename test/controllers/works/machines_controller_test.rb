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
    assert_difference('MachineResult.count') do
      post :create, params: {
        work_id: works(:work_not_fixed),
        machine_hours: { 4 => { WorkResult.last.id => 5 }}
      }
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))
  end
end
