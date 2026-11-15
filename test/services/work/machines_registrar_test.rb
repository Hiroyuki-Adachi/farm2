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
  test "金額は時間と別項目に保存し0円も保持し空欄で削除する" do
    set_direct_amount(@machine, @result)
    assert @work.regist_machines({}, @machine.id => { @result.id => "9999999" })
    entry = @work.machine_results.find_by!(machine: @machine)
    assert_equal 9_999_999, entry.input_amount
    assert_equal 0, entry.hours
    assert @work.regist_machines({}, @machine.id => { @result.id => "0" })
    assert_equal 0, entry.reload.input_amount
    assert @work.regist_machines({}, @machine.id => { @result.id => "" })
    assert_not MachineResult.exists?(entry.id)
    assert_not MachineRemark.exists?(@remark.id)
  end

  test "不正な金額では他の機械の変更も含めてロールバックする" do
    set_direct_amount(@machine, @result)
    other_machine = machines(:taueki_1)
    ["-1", "1.5", "10000000", "abc"].each do |value|
      @work.errors.clear
      assert_not @work.regist_machines({ other_machine.id => { @result.id => "2" } }, @machine.id => { @result.id => value })
      assert_not @work.machine_results.exists?(machine: other_machine)
      assert_nil @work.machine_results.find_by!(machine: @machine).input_amount
    end
  end

  test "作業と機械ごとの合計額も7桁以内に制限する" do
    set_direct_amount(@machine, @result)
    set_direct_amount(@machine, @other_result)
    assert_not @work.regist_machines({}, @machine.id => { @result.id => "9999999", @other_result.id => "1" })
    assert_nil @work.machine_results.find_by!(machine: @machine).input_amount
  end

  test "他の作業の作業者への金額入力を無視する" do
    set_direct_amount(@machine, @result)
    foreign = work_results(:work_results1)
    MachineResult.where(machine: @machine, work_result: foreign).destroy_all
    assert_not_equal @work.id, foreign.work_id
    assert @work.regist_machines({}, @machine.id => { foreign.id => "5000" })
    assert_not MachineResult.exists?(machine: @machine, work_result: foreign)
  end

  def set_direct_amount(machine, work_result)
    header = machine.price_headers.find_by(validated_at: Date.new(1900, 1, 1)) || FactoryBot.create(:machine_price_header, machine: machine, validated_at: Date.new(1900, 1, 1))
    # 機械に既存のヘッダがある場合もこのテストの設定を優先する。
    machine.price_headers.where.not(id: header.id).destroy_all
    lease = machine.home_id == work_result.worker.home_id ? :normal : :lease
    header.details.find_or_initialize_by(lease_id: lease, work_kind_id: 0).update!(adjust_id: Adjust::AMOUNT.id, price: 0)
  end

end
