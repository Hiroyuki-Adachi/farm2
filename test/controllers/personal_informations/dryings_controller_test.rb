require 'test_helper'

class PersonalInformations::DryingsControllerTest < ActionController::TestCase
  setup do
    @user = users(:user31)
  end

  test "個人情報(乾燥調整)" do
    session[:user_id] = nil
    get :index, params: {personal_information_token: @user.token}
    assert_response :success
  end
end
