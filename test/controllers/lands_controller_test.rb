require 'test_helper'

class LandsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @land = lands(:lands1)
    @update = {
      place: "9999", owner_id: Home.first, manager_id: Home.first, area: 55.5,
      display_order: 99, target_flag: true, reg_area: 66.6
    }
  end

  test "土地マスタ一覧" do
    get :index
    assert_response :success
  end

  test "土地マスタ一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

  test "土地マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "土地マスタ新規作成(実行)" do
    assert_difference('Land.count') do
      post :create, params: {land: @update}
    end

    assert_redirected_to lands_path
  end

  test "土地マスタ変更(表示)" do
    get :edit, params: {id: @land}
    assert_response :success
  end

  test "土地マスタ変更(実行)" do
    assert_no_difference('Land.count') do
      patch :update, params: {id: @land, land: @update}
    end
    assert_redirected_to lands_path
  end

  test "土地マスタ削除" do
    assert_difference('Land.count', -1) do
      delete :destroy, params: {id: @land}
    end
    assert_redirected_to lands_path
  end
end
