require "test_helper"

class PersonalInformations::MailConfirmationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(メール認証)" do
    user_mail = 'test1@example.com'
    @user.update(mail: user_mail)
    get edit_personal_information_mail_confirmation_path(
      personal_information_token: @user.token,
      mail_token: @user.mail_confirmation_token
    )
    assert_response :success

    @user.reload
    assert_equal user_mail, @user.mail
    assert_not_nil @user.mail_confirmed_at
  end

  test "個人情報(メール認証)(失敗)" do
    user_mail = 'test1@example.com'
    @user.update(mail: user_mail)
    get edit_personal_information_mail_confirmation_path(
      personal_information_token: @user.token,
      mail_token: @user.mail_confirmation_token + 'A'
    )
    assert_response :success

    @user.reload
    assert_nil @user.mail_confirmed_at
  end
end
