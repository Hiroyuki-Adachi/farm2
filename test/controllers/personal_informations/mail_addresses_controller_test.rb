require "test_helper"

class PersonalInformations::MailAddressesControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper # ActionMailerのヘルパーをインクルード

  setup do
    @user = users(:users1)
  end

  test "メールアドレス設定(表示)" do
    get new_personal_information_mail_address_path(personal_information_token: @user.token)
    assert_response :success
  end

  test "メールアドレス設定(登録)" do
    user_mail = 'new_email@example.com'
    assert_emails 1 do
      post personal_information_mail_addresses_path(personal_information_token: @user.token),
           params: { user: { mail: user_mail } }
    end
    assert_redirected_to personal_information_path(token: @user.token)

    @user.reload
    assert_equal user_mail, @user.mail
  end

  test "メールアドレス設定(不正な形式は登録失敗)" do
    original_mail = @user.mail
    assert_no_emails do
      post personal_information_mail_addresses_path(personal_information_token: @user.token),
           params: { user: { mail: 'invalid-mail-address' } }
    end
    assert_response :unprocessable_content

    @user.reload
    assert_equal original_mail, @user.mail
  end

  test "メールアドレス設定(削除)" do
    assert_no_emails do
      post personal_information_mail_addresses_path(personal_information_token: @user.token),
           params: { user: { mail: '' } }
    end
    assert_redirected_to personal_information_path(token: @user.token)
    assert_equal 'メールアドレスを削除しました', flash[:notice]

    @user.reload
    assert_equal '', @user.mail
  end

  test "メールアドレス設定(重複は登録失敗)" do
    other_user = users(:user_manager)

    assert_no_emails do
      post personal_information_mail_addresses_path(personal_information_token: other_user.token),
           params: { user: { mail: @user.mail } }
    end
    assert_response :unprocessable_content

    other_user.reload
    assert_not_equal @user.mail, other_user.mail
  end
end
