require 'test_helper'

class WorkVerificationsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "日報検証一覧" do
    get :index
    assert_response :success
  end
end
