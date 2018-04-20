require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
    @create = { login_name: "testuser", password: "1111", password_confirmation: "1111" }
  end

  test "ユーザ一覧" do
    get :index
    assert_response :success
  end

  test "ユーザ一覧(システム管理者以外)" do
    session[:user_id] = users(:user_manager).id
    get :index
    assert_response :error
  end

  test "ユーザ新規作成(表示)" do
    get :new, worker_id: workers(:worker5).id
    assert_response :success
  end

  test "ユーザ新規作成(実行)" do
    assert_difference('User.count') do
      post :create, user: @create
    end
    assert_redirected_to users_path
  end

  test "ユーザ変更(表示)" do
    get :edit, id: @user
    assert_response :success
  end

  test "ユーザ変更(実行)" do
    patch :update, id: @user, user: { login_name: @user.login_name, password: "AAAA", password_confirmation: "AAA" }
    assert_response :success

    patch :update, id: @user, user: { login_name: @user.login_name, password: "AAAA", password_confirmation: "AAAA" }
    assert_redirected_to menu_index_path
  end

  test "ユーザ削除" do
    assert_difference('User.count', -1) do
      delete :destroy, id: @user
    end
    assert_redirected_to users_path
  end
end
