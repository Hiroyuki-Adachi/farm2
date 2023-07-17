require "test_helper"

class Users::QrControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "QR(表示)" do
    get :index
    assert_response :success
  end
end
