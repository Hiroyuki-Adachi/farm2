require "test_helper"

class ZgisControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "Z-GISデータ出力表示" do
    get :index
    assert_response :success
  end

  test "Z-GISデータ出力表示(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
