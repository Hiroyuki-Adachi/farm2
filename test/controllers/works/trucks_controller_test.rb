require "test_helper"

class Works::TrucksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @truck_type = machine_types(:machine_types_removable)
    organizations(:org).update!(truck_id: @truck_type.id)
    create_truck(homes(:home1))
    create_truck(homes(:home6))
  end

  test "軽トラック利用一覧に月トグルを表示する" do
    travel_to Date.new(2015, 6, 15) do
      get works_trucks_path
    end

    assert_response :success
    assert_select "#truck-month-tabs a", 12
    assert_select "#truck-month-tabs a.btn-primary", "6月"
  end

  test "当期ではない場合は期首月を初期選択する" do
    travel_to Date.new(2026, 5, 17) do
      get works_trucks_path
    end

    assert_response :success
    assert_select "#truck-month-tabs a.btn-primary", "1月"
  end

  test "月パラメータで選択月を切り替える" do
    get works_trucks_path, params: { month: "2015-04-01" }

    assert_response :success
    assert_select "#truck-month-tabs a.btn-primary", "4月"
  end

  test "軽トラックを所有する班を表示して左端の班を初期選択する" do
    get works_trucks_path

    assert_response :success
    assert_select "#truck-section-tabs a", 2
    assert_select "#truck-section-tabs a.btn-primary", sections(:sections0).name
    assert_select "th", text: homes(:home1).name
    assert_select "th", text: homes(:home6).name, count: 0
  end

  test "班パラメータで軽トラック列を絞り込む" do
    get works_trucks_path, params: { section_id: sections(:sections1).id }

    assert_response :success
    assert_select "#truck-section-tabs a.btn-primary", sections(:sections1).name
    assert_select "th", text: homes(:home1).name, count: 0
    assert_select "th", text: homes(:home6).name
  end

  private

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
