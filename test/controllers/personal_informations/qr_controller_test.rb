require "test_helper"

class PersonalInformations::QrControllerTest < ActionController::TestCase
  setup do
    @user = users(:users1)
    session[:user_id] = nil
  end

  test "個人情報(QR)" do
    get :index, params: {personal_information_token: @user.token}
    assert_response :success
  end
end
