require 'test_helper'

class TotalCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "原価一覧" do
    get :index
    assert_response :success
  end

  test "原価一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "原価計算" do
    post :create
    assert_redirected_to total_costs_path
  end
end
