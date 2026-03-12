require 'test_helper'

class LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @land = lands(:lands1)
    @home = homes(:home1)
    @update = {
      place: "9999", owner_id: @home.id, manager_id: @home.id, area: 55.5,
      target_flag: true, reg_area: 66.6
    }
  end

  test "土地マスタ一覧" do
    get lands_path
    assert_response :success
  end

  test "土地マスタ一覧(検証者以外)" do
    login_as(users(:user_user))
    get lands_path
    assert_response :error
  end

  test "土地マスタ新規作成(表示)" do
    get new_land_path
    assert_response :success
  end

  test "土地マスタ新規作成(実行)" do
    assert_difference('Land.kept.count') do
      post lands_path, params: {land: @update}
    end
    assert_redirected_to lands_path

    land = Land.last
    assert_equal @update[:place], land.place
    assert_equal @update[:owner_id], land.owner_id
    assert_equal @update[:manager_id], land.manager_id
    assert_equal @update[:area], land.area
    assert_equal @update[:target_flag], land.target_flag
    assert_equal @update[:reg_area], land.reg_area
  end

  test "土地マスタ変更(表示)" do
    get edit_land_path(@land)
    assert_response :success
  end

  test "土地マスタ変更(実行)" do
    assert_no_difference('Land.kept.count') do
      patch land_path(@land), params: {id: @land, land: @update}
    end
    assert_redirected_to lands_path

    @land.reload
    assert_equal @update[:place], @land.place
    assert_equal @update[:owner_id], @land.owner_id
    assert_equal @update[:manager_id], @land.manager_id
    assert_equal @update[:area], @land.area
    assert_equal @update[:target_flag], @land.target_flag
    assert_equal @update[:reg_area], @land.reg_area
  end

  test "土地マスタ削除" do
    assert_difference('Land.kept.count', -1) do
      delete land_path(@land)
    end
    assert_redirected_to lands_path

    assert_nil Land.kept.find_by(id: @land.id)
  end
end
