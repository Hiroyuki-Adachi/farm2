require "test_helper"

class Gaps::ChemicalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "GAP農薬台帳(一覧)" do
    get :index
    assert_response :success
  end
end
