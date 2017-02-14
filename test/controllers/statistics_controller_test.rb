require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  test "統計情報一覧" do
    get :index
    assert_response :success
  end
end
