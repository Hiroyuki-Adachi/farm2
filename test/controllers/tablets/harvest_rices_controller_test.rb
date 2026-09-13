require "test_helper"

class Tablets::HarvestRicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "タブレットメニューから水稲地図へ移動できる" do
    get tablets_menu_index_path
    assert_response :success
    assert_select "a[href=?]", map_tablets_harvest_rices_path, text: /収穫地図\(水稲\)/
  end

  test "未ログインでは閲覧できない" do
    logout
    get map_tablets_harvest_rices_path
    assert_response :redirect
  end

  test "管理権限のない利用者にはメニューと地図を公開しない" do
    login_as(users(:user_checker))
    get tablets_menu_index_path
    assert_select "a[href=?]", map_tablets_harvest_rices_path, count: 0
    get map_tablets_harvest_rices_path
    assert_response :error
  end

  test "年度ごとの俵数と色を表示し複数日の収穫は相加平均する" do
    land = create_land
    add_harvest(land, Date.new(2014, 9, 20), 10)
    add_harvest(land, Date.new(2015, 9, 20), 14)
    add_harvest(land, Date.new(2015, 9, 21), 18)
    systems(:s2014).update!(term_name: "第14期")
    systems(:s2015).update!(term_name: "第15期")

    get map_tablets_harvest_rices_path

    assert_response :success
    assert_select "h1", text: "収穫地図(水稲) 第15期"
    assert_select "#map[data-tablet=true][data-yield-key=bales]", 1
    assert_select "#land_#{land.id}[data-bales='8'][data-color='#34c759'][data-center]", 1
    assert_select "#toggle_land_labels[aria-pressed=true]", 1
    assert_select "span", text: "8（基準）"
    assert_select "a[aria-current=true][href=?]", map_tablets_harvest_rices_path(term: 2015)
    assert_select "a[href=?]", tablets_menu_index_path, text: "戻る"

    get map_tablets_harvest_rices_path, params: { term: 2014 }

    assert_response :success
    assert_select "h1", text: "収穫地図(水稲) 第14期"
    assert_select "#land_#{land.id}[data-bales='5'][data-color='#003a8c']", 1
    assert_select "a[aria-current=true][href=?]", map_tablets_harvest_rices_path(term: 2014)

    get map_tablets_harvest_rices_path, params: { term: 2015 }
    assert_select "#land_#{land.id}[data-bales='8']", 1
  end

  test "対象外の年度指定は今年度を表示する" do
    get map_tablets_harvest_rices_path, params: { term: 2013 }
    assert_response :success
    assert_select "a[aria-current=true][href=?]", map_tablets_harvest_rices_path(term: 2015)
  end

  test "前年度の設定がない場合も空の地図を表示できる" do
    systems(:s2014).delete
    get map_tablets_harvest_rices_path, params: { term: 2014 }
    assert_response :success
    assert_select "#map", 1
    assert_select "input[name=regions]", 0
  end

  test "収穫のない圃場と他組織の圃場は表示しない" do
    land = create_land
    other_land = lands(:land_other_org)
    get map_tablets_harvest_rices_path
    assert_response :success
    assert_select "#land_#{land.id}", 0
    assert_select "#land_#{other_land.id}", 0
  end

  private

  def create_land
    land = Land.create!(
      place: "rice-tablet", area: 10, owner: homes(:home1), manager: homes(:home1), target_flag: true,
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )
    land.land_costs.create!(activated_on: Date.new(2014, 1, 1), work_type_id: 6)
    land
  end

  def add_harvest(land, date, bags)
    work = Work.create!(
      term: date.year, worked_at: date, weather_id: :sunny, work_type_id: 6,
      work_kind_id: organizations(:org).harvesting_work_kind_id,
      start_at: "08:00", end_at: "17:00", name: "", remarks: ""
    )
    WorkLand.create!(work: work, land: land, work_type_id: 6)
    drying = Drying.create!(
      term: date.year, carried_on: date, home: homes(:home1), work_type_id: 6, drying_type_id: :self
    )
    drying.create_adjustment!(home: homes(:home1), rice_bag: bags)
  end
end
