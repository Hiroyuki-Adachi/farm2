require "test_helper"

class Works::TrucksRegistrationControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @truck_type = machine_types(:machine_types_removable)
    organizations(:org).update!(truck_id: @truck_type.id)
    @home1_truck = create_truck(homes(:home1))
    MachineKind.create!(machine_type: @truck_type, work_kind: work_kinds(:work_kind_shirokaki))
    @health = Health.create!(code: "T", name: "良好", display_order: 999, well_flag: true)
  end

  test "0以外の入力で machine_result を追加する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))

    assert_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "2.5" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    machine_result = MachineResult.find_by!(machine: @home1_truck, work_result: work_result)
    assert_equal 2.5, machine_result.hours
  end

  test "0以外の入力で既存 machine_result を更新する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))
    machine_result = MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "3.0" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 3.0, machine_result.reload.hours
  end

  test "0の入力で既存 machine_result を削除する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))
    machine_result = MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)

    assert_difference("MachineResult.count", -1) do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "0" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_nil MachineResult.find_by(id: machine_result.id)
  end

  test "軽トラ所有者と作業者世帯が一致しない machine_result 登録は無視する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    other_home_work_result = create_work_result(work, workers(:worker6))

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { other_home_work_result.id => "2.5" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_nil MachineResult.find_by(machine: @home1_truck, work_result: other_home_work_result)
  end

  test "締め済み work の machine_result 更新は無視する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki), fixed_at: Date.new(2015, 2, 28))
    work_result = create_work_result(work, workers(:worker1))
    machine_result = MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)

    assert_no_difference("MachineResult.count") do
      post works_trucks_path, params: filter_params.merge(
        machine_hours: { @home1_truck.id => { work_result.id => "0" } }
      )
    end

    assert_redirected_to works_trucks_path(filter_params)
    assert_equal 1.5, machine_result.reload.hours
  end

  private

  def filter_params
    {
      work_kind_id: work_kinds(:work_kind_shirokaki).id,
      month: Date.new(2015, 2, 1),
      section_id: sections(:sections0).id
    }
  end

  def create_work_result(work, worker)
    WorkResult.create!(work: work, worker: worker, health: @health, hours: 1.0, display_order: 1)
  end

  def create_work(worked_at, work_kind, fixed_at: nil)
    Work.create!(
      term: 2015,
      worked_at: worked_at,
      fixed_at: fixed_at,
      weather_id: :sunny,
      work_type: work_types(:work_type_koshi),
      work_kind: work_kind,
      name: "",
      remarks: "",
      start_at: Time.zone.local(2015, 2, 1, 8, 0, 0),
      end_at: Time.zone.local(2015, 2, 1, 17, 0, 0),
      organization: organizations(:org)
    )
  end

  def create_truck(home)
    Machine.create!(
      name: "",
      display_order: 1,
      validity_start_at: Date.new(2015, 1, 1),
      validity_end_at: Date.new(2099, 12, 31),
      machine_type_id: @truck_type.id,
      home_id: home.id,
      diesel_flag: false
    )
  end
end
