require "test_helper"

class Gaps::MaintenancesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP整備記録表(一覧)" do
    get gaps_maintenances_path
    assert_response :success
  end
end
