require "test_helper"

class Gaps::HealthControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "GAP体調確認表(一覧)" do
    get :index
    assert_response :success
  end
end
