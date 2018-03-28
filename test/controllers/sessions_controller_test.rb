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

  test "ログイン実行" do
    post :create, login_name: @user.login_name, password: "password"
    assert_redirected_to menu_index_path
    assert_equal session[:user_id], @user.id
  end
end
