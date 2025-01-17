require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "ログイン画面" do
    get new_session_path
    assert_response :success
  end

  test "ログイン実行(認証エラー)" do
    post sessions_path, params: {login_name: @user.login_name, password: "hogehoge"}
    assert_template :_flash
    assert_nil session[:user_id]
  end

  test "ログイン実行(成功)" do
    post sessions_path, params: {login_name: @user.login_name, password: "password"}
    assert_redirected_to menu_index_path
    assert_equal @user.id, session[:user_id]
  end

  test "ログアウト" do
    login_as(@user)
    get sessions_path
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
