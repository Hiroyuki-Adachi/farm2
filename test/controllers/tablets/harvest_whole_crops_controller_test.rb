require "test_helper"

class Tablets::HarvestWholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "タブレットメニューから収穫地図へ移動できる" do
    get tablets_menu_index_path
    assert_response :success
    assert_select "a[href=?]", map_tablets_harvest_whole_crops_path
  end

  test "未ログインでは地図を閲覧できない" do
    logout
    get map_tablets_harvest_whole_crops_path
    assert_response :redirect
  end

  test "収穫地図(WCS)を収穫量に応じて色分け表示する" do
    map_land = Land.create!(
      place: "9999-2",
      owner: homes(:home1),
      manager: homes(:home1),
      area: 20.0,
      target_flag: true,
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )
    work = create_wcs_work(worked_at: Date.new(2015, 6, 1))
    work_land = WorkLand.create!(work: work, land: map_land, work_type_id: 15)
    WholeCropLand.create!(work_whole_crop: work.whole_crop, work_land: work_land, rolls: 20)

    get map_tablets_harvest_whole_crops_path

    assert_response :success
    assert_select "#map", 1
    assert_select "input[type=hidden][name=regions][data-id='#{map_land.id}'][data-color='#34c759'][data-rolls='10']", 1
    assert_select "a[href=?]", tablets_menu_index_path, text: "戻る"
  end

  test "同じ圃場で複数回収穫した場合は初日の10a換算値のみ表示する" do
    map_land = Land.create!(
      place: "9999-3",
      owner: homes(:home1),
      manager: homes(:home1),
      area: 20.0,
      target_flag: true,
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )
    first_work = create_wcs_work(worked_at: Date.new(2015, 6, 1))
    first_work_land = WorkLand.create!(work: first_work, land: map_land, work_type_id: 15)
    WholeCropLand.create!(work_whole_crop: first_work.whole_crop, work_land: first_work_land, rolls: 20)

    second_work = create_wcs_work(worked_at: Date.new(2015, 7, 1))
    second_work_land = WorkLand.create!(work: second_work, land: map_land, work_type_id: 15)
    WholeCropLand.create!(work_whole_crop: second_work.whole_crop, work_land: second_work_land, rolls: 10)

    get map_tablets_harvest_whole_crops_path

    assert_response :success
    assert_select "input[type=hidden][name=regions][data-id='#{map_land.id}'][data-color='#34c759'][data-rolls='10']", 1
  end

  test "収穫実績(whole_crop_lands)のない圃場は地図に表示しない" do
    map_land = Land.create!(
      place: "9999-4",
      owner: homes(:home1),
      manager: homes(:home1),
      area: 20.0,
      target_flag: true,
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )
    WorkLand.create!(work: works(:work_wcs2), land: map_land, work_type_id: 15)

    get map_tablets_harvest_whole_crops_path

    assert_response :success
    assert_select "input[type=hidden][name=regions][data-id='#{map_land.id}']", 0
  end

  test "収穫地図に他組織の土地を表示しない" do
    other_land = lands(:land_other_org)
    other_land.update!(region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))")
    other_work = works(:work_other_org)
    other_whole_crop = WorkWholeCrop.create!(work: other_work)
    other_work_land = WorkLand.create!(work: other_work, land: other_land, work_type_id: 11)
    WholeCropLand.create!(work_whole_crop: other_whole_crop, work_land: other_work_land, rolls: 10)

    get map_tablets_harvest_whole_crops_path

    assert_response :success
    assert_select "input[type=hidden][name=regions][data-id='#{other_land.id}']", 0
  end

  test "収穫地図(WCS)(検証者以外)" do
    login_as(users(:user_checker))
    get map_tablets_harvest_whole_crops_path
    assert_response :error
  end

  test "前年度と今年度の収穫量を切り替える" do
    land = Land.create!(
      place: "9999-5", owner: homes(:home1), manager: homes(:home1), area: 20, target_flag: true,
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )
    [[2014, 14], [2015, 20]].each do |term, rolls|
      work = create_wcs_work(worked_at: Date.new(term, 6, 1))
      work.update!(term: term)
      work_land = WorkLand.create!(work: work, land: land, work_type_id: 15)
      WholeCropLand.create!(work_whole_crop: work.whole_crop, work_land: work_land, rolls: rolls)
    end

    get map_tablets_harvest_whole_crops_path
    assert_response :success
    assert_select "#land_#{land.id}[data-rolls='10'][data-place][data-area][data-center]", 1
    assert_select "#toggle_land_labels[aria-pressed='true']", 1
    assert_select "a[aria-current='true'][href=?]", map_tablets_harvest_whole_crops_path(term: 2015)

    get map_tablets_harvest_whole_crops_path, params: { term: 2014 }
    assert_response :success
    assert_select "#land_#{land.id}[data-rolls='7']", 1
    assert_select "a[aria-current='true'][href=?]", map_tablets_harvest_whole_crops_path(term: 2014)

    get map_tablets_harvest_whole_crops_path, params: { term: 2015 }
    assert_select "#land_#{land.id}[data-rolls='10']", 1
  end

  test "対象外の年度を指定すると今年度を表示する" do
    get map_tablets_harvest_whole_crops_path, params: { term: 2013 }
    assert_response :success
    assert_select "a[aria-current='true'][href=?]", map_tablets_harvest_whole_crops_path(term: 2015)
  end

  private

  def create_wcs_work(worked_at:)
    work = Work.create!(
      term: '2015',
      worked_at: worked_at,
      weather_id: :sunny,
      work_type_id: 15,
      work_kind_id: works(:work_wcs2).work_kind_id,
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )
    WorkWholeCrop.create!(work: work)
    work
  end
end
