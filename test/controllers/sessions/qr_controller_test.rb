require "test_helper"

class Sessions::QrControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
  end

  test "Tablet(QR認証)" do
    session[:user_id] = nil
    @user.regenerate_token!
    post :create, params: {qr_code: @user.user_token.token }
    assert_response :success
    assert_equal session[:user_id], @user.id
  end
end
