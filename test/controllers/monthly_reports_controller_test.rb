require 'test_helper'

class MonthlyReportsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "月報画面" do
    get :index
    assert_response :success
  end
end
