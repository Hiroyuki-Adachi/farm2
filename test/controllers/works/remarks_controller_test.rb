require "test_helper"

class Works::RemarksControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
    @work = works(:work_not_fixed)
  end

  test "作業変更(ヒヤリ)(表示)" do
    get :new, params: {work_id: @work}
    assert_response :success

    get :new, params: {work_id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(ヒヤリ)(変更)" do
    machine = machines(:taueki_1)
    assert_difference('MachineRemark.count') do
      post :create, params: {work_id: @work, :machine_remarks => {machine.id => {work_id: @work, machine_id: machine.id, other_remarks: "TEST"}}}
    end
    assert_redirected_to work_path(id: @work)
  end
end
