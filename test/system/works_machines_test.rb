require "application_system_test_case"

class WorksMachinesTest < ApplicationSystemTestCase
  test "稼働をゼロにすると備考も削除され再登録時に復活しない" do
    work = works(:work_not_fixed)
    work.machine_results.destroy_all
    machine = machines(:machines1)
    MachineKind.create!(work_kind: work.work_kind, machine_type: machine.machine_type)
    result = work_results(:work_results_not_fixed)
    record = MachineResult.create!(machine: machine, work_result: result, hours: 1)
    remark = MachineRemark.create!(work: work, machine: machine, care_remarks: "削除確認用の備考")

    visit root_path
    fill_in 'login_name', with: users(:users1).login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'

    visit new_work_machine_path(work_id: work)
    fill_in "machine_hours[#{machine.id}][#{result.id}]", with: '0'
    click_button '登録'

    assert_current_path work_path(work)
    assert_not MachineResult.exists?(record.id)
    assert_not MachineRemark.exists?(remark.id)

    visit new_work_machine_path(work_id: work)
    assert_field "machine_hours[#{machine.id}][#{result.id}]", with: '0'
    fill_in "machine_hours[#{machine.id}][#{result.id}]", with: '1'
    click_button '登録'

    assert_current_path new_work_remark_path(work_id: work)
    assert_field "machine_remarks[#{machine.id}][care_remarks]", with: ""
  end
end
