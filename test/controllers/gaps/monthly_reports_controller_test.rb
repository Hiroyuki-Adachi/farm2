require "test_helper"

class Gaps::MonthlyReportsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "GAP作業月毎記録表(一覧)" do
    get :index
    assert_response :success
  end
end
