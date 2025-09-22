require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @create = {login_name: "testuser", password: "1111", password_confirmation: "1111"}
  end

  test "ユーザ一覧" do
    get users_path
    assert_response :success
  end

  test "ユーザ一覧(システム管理者以外)" do
    login_as(users(:user_manager))
    get users_path
    assert_response :error
  end

  test "ユーザ新規作成(表示)" do
    get new_user_path, params: {worker_id: workers(:worker5).id}
    assert_response :success
  end

  test "ユーザ新規作成(実行)" do
    assert_difference('User.count') do
      post users_path, params: {user: @create}
    end
    assert_redirected_to users_path

    # 作成したユーザを検証
    user = User.last
    assert_equal @create[:login_name], user.login_name
  end

  test "ユーザ変更(表示)" do
    get edit_user_path(@user)
    assert_response :success
  end

  test "ユーザ変更(実行)" do
    patch user_path(@user), params: {user: {login_name: 'updateuser', password: "AAAA", password_confirmation: "AAA"}}
    assert_response :unprocessable_content

    patch user_path(@user), params: {user: {login_name: 'updateuser', password: "AAAA", password_confirmation: "AAAA"}}
    assert_redirected_to menu_index_path

    @user.reload
    assert_equal 'updateuser', @user.login_name
  end

  test "ユーザ削除" do
    assert_difference('User.count', -1) do
      delete user_path(@user)
    end
    assert_redirected_to users_path
    assert_nil User.find_by(id: @user.id)
  end
end
