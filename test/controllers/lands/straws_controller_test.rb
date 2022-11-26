require "test_helper"

class Lands::StrawsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "稲わら一覧(初期表示)" do
    get :index
    assert_response :success
  end
end
