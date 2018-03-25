require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
  end

  test "パスワード変更(表示)" do
    get :edit, id: @user
    assert_response :success
  end

  test "パスワード変更(実行)" do
    patch :update, id: @user, user: { login_name: @user.login_name, password: "AAAA", password_confirmation: "AAA" }
    assert_response :success

    patch :update, id: @user, user: { login_name: @user.login_name, password: "AAAA", password_confirmation: "AAAA" }
    assert_redirected_to menu_index_path
  end
end
