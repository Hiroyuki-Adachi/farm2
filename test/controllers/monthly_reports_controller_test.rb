require 'test_helper'

class MonthlyReportsControllerTest < ActionController::TestCase
  test "月報画面" do
    get :index
    assert_response :success
  end
end
