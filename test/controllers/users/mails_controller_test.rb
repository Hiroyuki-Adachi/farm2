require "test_helper"

class Users::MailsControllerTest < ActionDispatch::IntegrationTest
  include ActionMailer::TestHelper # ActionMailerのヘルパーをインクルード

  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "メールアドレス設定(表示)" do
    get new_users_mail_path
    assert_response :success
  end

  test "メールアドレス設定(登録)" do
    user_mail = 'new_email@example.com'
    assert_emails 1 do
      post users_mails_path, params: { user: { mail: user_mail } }
    end
    assert_redirected_to menu_index_path

    @user.reload
    assert_equal user_mail, @user.mail
  end
end
