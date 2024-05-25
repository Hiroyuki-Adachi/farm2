require "test_helper"

class PersonalInformations::IpConfirmationsControllerTest < ActionController::TestCase
  setup do
    user = users(:users1)
    @ip = IpList.white_ip!('5.5.5.5', user)
    session[:user_id] = nil
  end

  test "IP情報(メール認証)" do
    get :edit, params: {personal_information_token: @ip.created_user.token, ip_token: @ip.confirmation_token}
    assert_response :success

    @ip.reload
    assert_not_nil @ip.expired_on
    assert_operator @ip.expired_on, :>, Time.current
  end
end
