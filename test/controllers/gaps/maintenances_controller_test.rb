require "test_helper"

class Gaps::MaintenancesControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "GAP整備記録表(一覧)" do
    get :index
    assert_response :success
  end
end
