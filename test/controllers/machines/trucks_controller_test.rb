require "test_helper"

class Machines::TrucksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @truck_type = machine_types(:machine_types_removable)
    organizations(:org).update!(truck_id: @truck_type.id)

    @truck = Machine.create!(
      name: "軽トラック",
      display_order: 1,
      validity_start_at: Date.new(2010, 1, 1),
      validity_end_at: Date.new(2099, 12, 31),
      machine_type_id: @truck_type.id,
      home_id: homes(:home1).id
    )
  end

  test "軽トラック保守一覧に所有状態を表示する" do
    get machines_trucks_path

    assert_response :success
    assert_select "input#home_#{homes(:home1).id}[name=?][value=?][checked=checked]",
                  "home_ids[]", homes(:home1).id.to_s
    assert_select "input#home_#{homes(:home2).id}[name=?][value=?][checked=checked]",
                  "home_ids[]", homes(:home2).id.to_s, count: 0
  end

  test "別組織の所有者は表示せず登録も受け付けない" do
    get machines_trucks_path

    assert_response :success
    assert_select "td", text: homes(:home_other_org).name, count: 0

    assert_no_difference("Machine.kept.count") do
      post machines_trucks_path, params: { home_ids: [homes(:home1).id, homes(:home_other_org).id] }
    end

    assert_nil Machine.kept.find_by(machine_type_id: @truck_type.id, home_id: homes(:home_other_org).id)
  end

  test "軽トラック保守一覧(検証者以外)" do
    login_as(users(:user_user))
    get machines_trucks_path
    assert_response :error
  end

  test "賃借量が登録されている軽トラックはチェックを外せない" do
    create_machine_result(@truck)

    get machines_trucks_path

    assert_response :success
    assert_select "input#home_#{homes(:home1).id}[disabled=disabled]"
    assert_select "td", "賃借量が登録されています"
  end

  test "賃借量が登録されている軽トラックは登録時に所有解除しない" do
    create_machine_result(@truck)

    assert_no_difference("Machine.kept.count") do
      post machines_trucks_path, params: { home_ids: [] }
    end

    assert_redirected_to machines_trucks_path
    assert_predicate @truck.reload, :kept?
  end

  test "チェック状態に合わせて軽トラックを追加削除する" do
    assert_difference("Machine.kept.count", 0) do
      post machines_trucks_path, params: { home_ids: [homes(:home2).id] }
    end

    assert_redirected_to machines_trucks_path
    assert_predicate @truck.reload, :discarded?

    created_truck = Machine.kept.find_by!(machine_type_id: @truck_type.id, home_id: homes(:home2).id)
    assert_equal "", created_truck.name
    assert_equal 1, created_truck.display_order
    assert_equal Time.zone.today.beginning_of_month, created_truck.validity_start_at
    assert_equal Date.new(2099, 12, 31), created_truck.validity_end_at
    assert_equal @truck_type.id, created_truck.machine_type_id
    assert_equal homes(:home2).id, created_truck.home_id
    assert_not created_truck.diesel_flag
  end

  test "削除済み軽トラックを再利用して所有状態を戻す" do
    @truck.discard

    assert_no_difference("Machine.with_discarded.count") do
      post machines_trucks_path, params: { home_ids: [homes(:home1).id] }
    end

    assert_redirected_to machines_trucks_path
    assert_predicate @truck.reload, :kept?
  end

  private

  def create_machine_result(machine)
    health = Health.create!(code: "T", name: "良好", display_order: 999, well_flag: true)
    work_result = WorkResult.find_or_create_by!(work: works(:works1), worker: workers(:worker1)) do |result|
      result.health = health
      result.hours = 1.0
      result.display_order = 1
    end
    MachineResult.find_or_create_by!(machine: machine, work_result: work_result) do |result|
      result.hours = 1.0
    end
  end
end
