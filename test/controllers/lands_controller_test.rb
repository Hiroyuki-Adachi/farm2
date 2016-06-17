require 'test_helper'

class LandsControllerTest < ActionController::TestCase
  setup do
    @land = Land.first
    @update = { place: "9999", owner_id: Home.first, manager_id: Home.first, area: 55.5, display_order: 99, target_flag: true }
  end

  test "土地マスタ一覧" do
    get :index
    assert_response :success
  end

  test "土地マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "土地マスタ新規作成(実行)" do
    assert_difference('Land.count') do
      post :create, land: @update
    end

    assert_redirected_to lands_path
  end

  test "土地マスタ変更(表示)" do
    get :edit, id: @land
    assert_response :success
  end

  test "土地マスタ変更(実行)" do
    patch :update, id: @land, land: @update
    assert_redirected_to lands_path
  end

  test "土地マスタ削除" do
    assert_difference('Land.count', -1) do
      delete :destroy, id: @land
    end
    assert_redirected_to lands_path
  end
end
