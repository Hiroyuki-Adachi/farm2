require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "ログイン画面(パブリック)" do
    get new_session_path, headers: { 'REMOTE_ADDR' => '1.1.1.1' }
    assert_redirected_to new_ip_list_path
  end

  test "ログイン画面(ホワイトリスト)" do
    get new_session_path, headers: { 'REMOTE_ADDR' => '3.3.3.3' }
    assert_response :success
  end

  test "ログイン画面(ブラックリスト)" do
    get new_session_path, headers: { 'REMOTE_ADDR' => '4.4.4.4' }
    assert_response :service_unavailable
  end

  test "ログイン実行(認証エラー)" do
    post sessions_path, params: { login_name: @user.login_name, password: "hogehoge" }
    assert_select 'div.alert.alert-danger', I18n.t("session.login_error")
    assert_nil session[:user_id]
    assert_equal 1, @user.reload.failed_login_attempts
  end

  test "ログイン実行(成功)" do
    @user.update!(failed_login_attempts: 2, locked_at: nil)

    post sessions_path, params: { login_name: @user.login_name, password: "password" }
    assert_redirected_to menu_index_path
    assert_equal @user.id, session[:user_id]
    assert_equal "PC", session[:access_target]
    assert_equal 0, @user.reload.failed_login_attempts
    assert_nil @user.locked_at
  end

  test "ログイン実行(閾値到達でロック)" do
    (User::MAX_FAILED_LOGIN_ATTEMPTS - 1).times do
      post sessions_path, params: { login_name: @user.login_name, password: "hogehoge" }
    end

    @user.reload
    assert_equal User::MAX_FAILED_LOGIN_ATTEMPTS - 1, @user.failed_login_attempts
    assert_nil @user.locked_at

    post sessions_path, params: { login_name: @user.login_name, password: "hogehoge" }

    assert_select 'div.alert.alert-danger', I18n.t("session.locked")
    assert_nil session[:user_id]
    assert_equal User::MAX_FAILED_LOGIN_ATTEMPTS, @user.reload.failed_login_attempts
    assert_not_nil @user.locked_at
  end

  test "ログイン実行(ロック中)" do
    @user.update!(failed_login_attempts: User::MAX_FAILED_LOGIN_ATTEMPTS, locked_at: Time.current)

    post sessions_path, params: { login_name: @user.login_name, password: "password" }

    assert_select 'div.alert.alert-danger', I18n.t("session.locked")
    assert_nil session[:user_id]
    assert_equal User::MAX_FAILED_LOGIN_ATTEMPTS, @user.reload.failed_login_attempts
  end

  test "ログイン実行(ロック期限切れ後は再ログインできる)" do
    @user.update!(
      failed_login_attempts: User::MAX_FAILED_LOGIN_ATTEMPTS,
      locked_at: (User::LOGIN_LOCKOUT_DURATION + 1.minute).ago
    )

    post sessions_path, params: { login_name: @user.login_name, password: "password" }

    assert_redirected_to menu_index_path
    assert_equal @user.id, session[:user_id]
    assert_equal 0, @user.reload.failed_login_attempts
    assert_nil @user.locked_at
  end

  test "ログアウト" do
    login_as(@user)
    get sessions_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
