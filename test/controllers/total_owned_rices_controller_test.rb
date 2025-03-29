require 'test_helper'

class TotalOwnedRicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "保有米集計一覧" do
    get total_owned_rices_path
    assert_response :success
  end

  test "保有米集計(管理者以外)" do
    login_as(users(:user_checker))
    get total_owned_rices_path
    assert_response :error
  end
end
