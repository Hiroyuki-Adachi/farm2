require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = nil
    @user = users(:users1)
  end

  test "ログイン画面" do
    get :new
    assert_response :success
  end

  test "ログイン画面(パブリック)" do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('1.1.1.1')
    get :new
    assert_redirected_to new_mail_path
  end

  test "ログイン画面(ホワイトリスト)" do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('3.3.3.3')
    get :new
    assert_response :success
  end

  test "ログイン画面(ブラックリスト)" do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('4.4.4.4')
    get :new
    assert_response :service_unavailable
  end

  test "ログイン実行(認証エラー)" do
    post :create, params: {login_name: @user.login_name, password: "hogehoge"}
    assert_template :_flash
    assert_nil session[:user_id]
  end

  test "ログイン実行(成功)" do
    post :create, params: {login_name: @user.login_name, password: "password"}
    assert_redirected_to menu_index_path
    assert_equal session[:user_id], @user.id
  end

  test "ログアウト" do
    session[:user_id] = @user.id
    get :index
    assert_redirected_to root_path
    assert_nil session[:user_id]
  end
end
