require "test_helper"

class PersonalInformations::MailConfirmationsControllerTest < ActionController::TestCase
  setup do
    @user = users(:users1)
    session[:user_id] = nil
  end

  test "個人情報(メール認証)" do
    @user.update(mail: 'test1@example.com')
    get :edit, params: {personal_information_token: @user.token, mail_token: @user.mail_confirmation_token}
    assert_response :success

    @user.reload
    assert_equal @user.mail, 'test1@example.com'
    assert_not_nil @user.mail_confirmed_at
  end
end
