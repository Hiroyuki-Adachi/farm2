require 'test_helper'

class LandPlacesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @land_place = land_places(:land_place0)
  end

  test "場所マスタ一覧" do
    get :index
    assert_response :success
    assert_not_nil assigns(:land_places)
  end

  test "場所マスタ一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "場所マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "場所マスタ新規作成(実行)" do
    assert_difference('LandPlace.count') do
      post :create, land_place: {name: "中央", display_order: 2, remarks: "備考です"}
    end
    assert_redirected_to land_places_path
  end

  test "場所マスタ変更(表示)" do
    get :edit, id: @land_place
    assert_response :success
  end

  test "場所マスタ変更(実行)" do
    patch :update, id: @land_place, land_place: {name: "東側", display_order: 99, remarks: ""}
    assert_redirected_to land_places_path
  end

  test "場所マスタ削除" do
    assert_difference('LandPlace.count', -1) do
      delete :destroy, id: @land_place
    end
    assert_redirected_to land_places_path
  end
end
