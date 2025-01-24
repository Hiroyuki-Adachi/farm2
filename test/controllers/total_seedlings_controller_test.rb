require 'test_helper'

class TotalSeedlingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "育苗集計" do
    get total_seedlings_path
    assert_response :success
  end

  test "育苗集計(管理者以外)" do
    login_as(users(:user_checker))
    get total_seedlings_path
    assert_response :error
  end
end
