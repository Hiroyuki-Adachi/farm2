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

  test "メールアドレス設定(不正な形式は登録失敗)" do
    original_mail = @user.mail
    assert_no_emails do
      post users_mails_path, params: { user: { mail: 'invalid-mail-address' } }
    end
    assert_response :unprocessable_content

    @user.reload
    assert_equal original_mail, @user.mail
  end

  test "メールアドレス設定(削除)" do
    assert_no_emails do
      post users_mails_path, params: { user: { mail: '' } }
    end
    assert_redirected_to menu_index_path
    assert_equal 'メールアドレスを削除しました', flash[:notice]

    @user.reload
    assert_equal '', @user.mail
  end

  test "メールアドレス設定(重複は登録失敗)" do
    other_user = users(:user_manager)
    login_as(other_user)

    assert_no_emails do
      post users_mails_path, params: { user: { mail: @user.mail } }
    end
    assert_response :unprocessable_content

    other_user.reload
    assert_not_equal @user.mail, other_user.mail
  end
end
