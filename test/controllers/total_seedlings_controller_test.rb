require 'test_helper'

class TotalSeedlingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "育苗集計" do
    get :index
    assert_response :success
  end

  test "育苗集計(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
