require 'test_helper'

class StatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "統計情報一覧" do
    get statistics_path
    assert_response :success
  end

  test "統計情報一覧(利用者)" do
    login_as(users(:user_user))
    get statistics_path
    assert_response :error
  end
end
