require "test_helper"

class Statistics::WorkDaysControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "世帯別作業日数一覧" do
    get :index
    assert_response :success
  end
end
