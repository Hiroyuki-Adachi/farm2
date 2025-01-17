require 'test_helper'

class LandPlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @land_place = land_places(:land_place0)
  end

  test "場所マスタ一覧" do
    get land_places_path
    assert_response :success
    assert_not_nil assigns(:land_places)
  end

  test "場所マスタ一覧(管理者以外)" do
    login_as(users(:user_checker))
    get land_places_path
    assert_response :error
  end

  test "場所マスタ新規作成(表示)" do
    get new_land_place_path
    assert_response :success
  end

  test "場所マスタ新規作成(実行)" do
    new_land_place = {name: "中央", display_order: 2, remarks: "備考です"}
    assert_difference('LandPlace.count') do
      post land_places_path, params: {land_place: new_land_place}
    end
    assert_redirected_to land_places_path

    land_place = LandPlace.last
    assert_equal new_land_place[:name], land_place.name
    assert_equal new_land_place[:display_order], land_place.display_order
    assert_equal new_land_place[:remarks], land_place.remarks
  end

  test "場所マスタ変更(表示)" do
    get edit_land_place_path(@land_place)
    assert_response :success
  end

  test "場所マスタ変更(実行)" do
    new_land_place = {name: "東側", display_order: 99, remarks: "ダミー備考だよ!!"}
    patch land_place_path(@land_place), params: {land_place: new_land_place}
    assert_redirected_to land_places_path

    @land_place.reload
    assert_equal new_land_place[:name], @land_place.name
    assert_equal new_land_place[:display_order], @land_place.display_order
    assert_equal new_land_place[:remarks], @land_place.remarks
  end

  test "場所マスタ削除" do
    assert_difference('LandPlace.count', -1) do
      delete land_place_path(@land_place)
    end
    assert_redirected_to land_places_path

    assert_nil LandPlace.find_by(id: @land_place.id)
  end
end
