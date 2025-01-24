require "test_helper"

class Works::RemarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @work = works(:work_not_fixed)
    login_as(@user)
  end

  test "作業変更(ヒヤリ)(表示)" do
    get new_work_remark_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(ヒヤリ)(表示)(確定済)" do
    get new_work_remark_path(work_id: works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(ヒヤリ)(変更)" do
    machine = machines(:taueki_1)
    machine_remarks = {
      machine.id => {
        work_id: @work.id,
        machine_id: machine.id,
        care_remarks: "TEST1",
        danger_remarks: "TEST2",
        other_remarks: "TEST3",
      }
    }
    assert_difference('MachineRemark.count') do
      post work_remarks_path(work_id: @work), params: {
        machine_remarks: machine_remarks
      }
    end
    assert_redirected_to work_path(id: @work)

    created_machine_remark = MachineRemark.last
    assert_equal @work.id, created_machine_remark.work_id
    assert_equal machine.id, created_machine_remark.machine_id
    assert_equal machine_remarks[machine.id][:care_remarks], created_machine_remark.care_remarks
    assert_equal machine_remarks[machine.id][:danger_remarks], created_machine_remark.danger_remarks
    assert_equal machine_remarks[machine.id][:other_remarks], created_machine_remark.other_remarks
  end
end
