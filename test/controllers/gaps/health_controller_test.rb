require "test_helper"

class Gaps::HealthControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP体調確認表(一覧)" do
    get gaps_health_index_path
    assert_response :success
  end
end
