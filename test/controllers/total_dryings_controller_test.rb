require 'test_helper'

class TotalDryingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "乾燥集計一覧" do
    get total_dryings_path
    assert_response :success
  end

  test "乾燥集計(管理者以外)" do
    login_as(users(:user_checker))
    get total_dryings_path
    assert_response :error
  end
end
