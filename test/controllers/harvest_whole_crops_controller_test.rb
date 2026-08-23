require 'test_helper'

class HarvestWholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "収穫一覧(WCS)" do
    get harvest_whole_crops_path
    assert_response :success
  end

  test "収穫一覧の取得対象に他組織の作業を含めない" do
    works(:work_other_org).update!(worked_at: Date.new(2015, 12, 31))
    WorkWholeCrop.create!(work: works(:work_other_org))

    get harvest_whole_crops_path

    assert_response :success
    assert_not_includes response.body, "2015-12-31"
  end

  test "収穫一覧(WCS)(検証者以外)" do
    login_as(users(:user_checker))
    get harvest_whole_crops_path
    assert_response :error
  end

  test "収穫一覧(WCS)に地図ボタンを表示する" do
    get harvest_whole_crops_path
    assert_response :success
    assert_select "a.btn-info[href=?]", map_harvest_whole_crops_path, text: "地図"
  end

  test "収穫地図(WCS)を表示する" do
    map_land = lands(:lands1)
    WorkLand.create!(work: works(:work_wcs2), land: map_land, work_type_id: 15)

    get map_harvest_whole_crops_path

    assert_response :success
    assert_select "#map", 1
    assert_select "input[type=hidden][name=regions][data-id='#{map_land.id}'][data-color='#ffffff']", 1
    assert_select "a[href=?]", harvest_whole_crops_path, text: "戻る"
  end

  test "収穫地図に他組織の土地を表示しない" do
    other_land = lands(:land_other_org)
    other_land.update!(region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))")
    other_work = works(:work_other_org)
    WorkWholeCrop.create!(work: other_work)
    WorkLand.create!(work: other_work, land: other_land, work_type_id: 11)

    get map_harvest_whole_crops_path

    assert_response :success
    assert_select "input[type=hidden][name=regions][data-id='#{other_land.id}']", 0
  end

  test "収穫地図(WCS)(検証者以外)" do
    login_as(users(:user_checker))
    get map_harvest_whole_crops_path
    assert_response :error
  end
end
