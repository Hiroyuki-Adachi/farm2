require "test_helper"

class Works::TrucksInputsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @truck_type = machine_types(:machine_types_removable)
    organizations(:org).update!(truck_id: @truck_type.id)
    @home1_truck = create_truck(homes(:home1))
    @home6_truck = create_truck(homes(:home6))
    MachineKind.create!(machine_type: @truck_type, work_kind: work_kinds(:work_kind_shirokaki))
    @health = Health.create!(code: "T", name: "良好", display_order: 999, well_flag: true)
  end

  test "作業者の世帯と軽トラ所有者が一致するセルに時間入力欄を表示する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))
    MachineResult.create!(machine: @home1_truck, work_result: work_result, hours: 1.5)

    get works_trucks_path, params: { work_kind_id: work_kinds(:work_kind_shirokaki).id, month: "2015-02-01" }

    assert_response :success
    assert_select "input[name=?][type=number][min=?][max=?][step=?][required=required][value=?]",
                  "machine_hours[#{@home1_truck.id}][#{work_result.id}]", "0", "9.5", "0.5", "1.5"
    assert_select "input[name^=?]", "machine_hours[#{@home6_truck.id}]", count: 0
  end

  test "締め済み作業の時間入力欄は readonly で表示する" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki), fixed_at: Date.new(2015, 2, 28))
    work_result = create_work_result(work, workers(:worker1))

    get works_trucks_path, params: { work_kind_id: work_kinds(:work_kind_shirokaki).id, month: "2015-02-01" }

    assert_response :success
    assert_select "input[name=?][readonly=readonly]", "machine_hours[#{@home1_truck.id}][#{work_result.id}]"
  end

  test "未締め作業の時間入力欄は readonly にしない" do
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    work_result = create_work_result(work, workers(:worker1))

    get works_trucks_path, params: { work_kind_id: work_kinds(:work_kind_shirokaki).id, month: "2015-02-01" }

    assert_response :success
    assert_select "input[name=?][readonly=readonly]", "machine_hours[#{@home1_truck.id}][#{work_result.id}]", count: 0
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
