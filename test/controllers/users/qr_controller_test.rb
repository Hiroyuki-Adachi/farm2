require "test_helper"

class Users::QrControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "QR(表示)" do
    login_as(@user)
    get users_qr_index_path
    assert_response :success
    assert_select 'img[src*="personal_information"]'
  end

  test "QR(未ログイン)" do
    get users_qr_index_path
    assert_redirected_to root_path
  end
end
