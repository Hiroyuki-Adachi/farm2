require "test_helper"

class Work::MachinesRegistrarTest < ActiveSupport::TestCase
  setup do
    @work = works(:work_not_fixed)
    @work.machine_results.destroy_all
    @machine = machines(:machines1)
    @result = work_results(:work_results_not_fixed)
    @other_result = @result.dup
    @other_result.worker = workers(:worker1)
    @other_result.save!
    MachineResult.create!(machine: @machine, work_result: @result, hours: 1)
    @remark = MachineRemark.create!(work: @work, machine: @machine, care_remarks: "保守備考")
  end

  test "全作業者の稼働削除時は対象機械の備考だけを削除する" do
    MachineResult.create!(machine: @machine, work_result: @other_result, hours: 2)
    other_machine_remark = MachineRemark.create!(work: @work, machine: machines(:taueki_1), care_remarks: "別機械")
    other_work_remark = MachineRemark.create!(work: works(:works1), machine: @machine, care_remarks: "別日報")

    @work.regist_machines(@machine.id => { @result.id => "0", @other_result.id => "0" })

    assert_not @work.machine_results.exists?(machine_id: @machine.id)
    assert_not MachineRemark.exists?(@remark.id)
    assert MachineRemark.exists?(other_machine_remark.id)
    assert MachineRemark.exists?(other_work_remark.id)
  end

  test "別の作業者の稼働が残る場合は備考を保持する" do
    MachineResult.create!(machine: @machine, work_result: @other_result, hours: 2)

    @work.regist_machines(@machine.id => { @result.id => "0" })

    assert_not @work.machine_results.exists?(work_result_id: @result.id, machine_id: @machine.id)
    assert @work.machine_results.exists?(work_result_id: @other_result.id, machine_id: @machine.id)
    assert MachineRemark.exists?(@remark.id)
  end

  test "同じ登録で別作業者に稼働を移す場合は備考を保持する" do
    @work.regist_machines(@machine.id => { @result.id => "0", @other_result.id => "1" })

    assert_not @work.machine_results.exists?(work_result_id: @result.id, machine_id: @machine.id)
    assert @work.machine_results.exists?(work_result_id: @other_result.id, machine_id: @machine.id)
    assert MachineRemark.exists?(@remark.id)
  end
end
