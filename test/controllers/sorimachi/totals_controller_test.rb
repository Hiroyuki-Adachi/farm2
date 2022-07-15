require "test_helper"

class Sorimachi::TotalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "農業簿記簡易集計(表示)" do
    get :index
    assert_response :success
  end
end
