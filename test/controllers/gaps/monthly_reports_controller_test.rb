require "test_helper"

class Gaps::MonthlyReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP作業月毎記録表(一覧)" do
    get gaps_monthly_reports_path
    assert_response :success
  end
end
