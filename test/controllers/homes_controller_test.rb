require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @home = homes(:home1)
    @update = { name: "試験", phonetic: "しけん", section_id: 1, member_flag: true, display_order: 99 }
  end

  test "世帯マスタ一覧" do
    get :index
    assert_response :success
  end

  test "世帯マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "世帯マスタ新規作成(実行)" do
    assert_difference('Home.count') do
      post :create, home: @update
    end

    assert_redirected_to homes_path
  end

  test "世帯マスタ変更(表示)" do
    get :edit, id: @home
    assert_response :success
  end

  test "世帯マスタ変更(実行)" do
    assert_no_difference('Home.count') do
      patch :update, id: @home, home: @update
    end
    assert_redirected_to homes_path
  end

  test "世帯マスタ削除" do
    assert_difference('Home.count', -1) do
      delete :destroy, id: @home
    end
    assert_redirected_to homes_path
  end
end
