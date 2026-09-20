require 'test_helper'

class HarvestRicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "収穫一覧(水稲)" do
    get harvest_rices_path
    assert_response :success
  end

  test "収穫一覧(水稲)(検証者以外)" do
    login_as(users(:user_checker))
    get harvest_rices_path
    assert_response :error
  end
  test "収穫一覧から地図に移動できる" do
    get harvest_rices_path
    assert_select "a[href=?]", map_harvest_rices_path, text: "地図"
  end

  test "収穫地図に凡例と戻るリンクを表示する" do
    get map_harvest_rices_path
    assert_response :success
    assert_select "#map[data-yield-key=bales]", 1
    assert_select "h1", text: "収穫地図(水稲)"
    assert_select "span", text: "8（基準）"
    assert_select "a[href=?]", harvest_rices_path, text: "戻る"
  end

  test "収穫地図の管理者権限を確認する" do
    login_as(users(:user_checker))
    get map_harvest_rices_path
    assert_response :error
  end

  test "圃場に60kg換算の俵数と色を埋め込む" do
    land = Land.create!(place: "rice-map", area: 10, owner: homes(:home1), manager: homes(:home1),
                        target_flag: true, region: "((35.474177,133.047340), (35.472866,133.047340),
                        (35.472648,133.049056))")
    land.land_costs.create!(activated_on: Date.new(2015, 1, 1), work_type_id: 6)
    work = Work.create!(term: 2015, worked_at: Date.new(2015, 9, 20), weather_id: :sunny,
                        work_type_id: 6, work_kind_id: organizations(:org).harvesting_work_kind_id,
                        start_at: "08:00", end_at: "17:00", name: "", remarks: "")
    WorkLand.create!(work: work, land: land, work_type_id: 6)
    drying = Drying.create!(term: 2015, carried_on: work.worked_at, home: homes(:home1),
                            work_type_id: 6, drying_type_id: :self)
    drying.create_adjustment!(home: homes(:home1), rice_bag: 16)

    get map_harvest_rices_path

    assert_response :success
    assert_select "input[name=regions][data-id='#{land.id}'][data-color='#34c759'][data-bales='8']", 1
  end
end
