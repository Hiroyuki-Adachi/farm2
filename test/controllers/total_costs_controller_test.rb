require 'test_helper'

class TotalCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "原価一覧" do
    get total_costs_path
    assert_response :success
  end

  test "原価一覧(管理者以外)" do
    login_as(users(:user_checker))
    get total_costs_path
    assert_response :error
  end

  test "原価計算" do
    post total_costs_path
    assert_redirected_to total_costs_path
  end
end
