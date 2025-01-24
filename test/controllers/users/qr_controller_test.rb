require "test_helper"

class Users::QrControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "QR(表示)" do
    get users_qr_index_path
    assert_response :success
  end
end
