require "test_helper"

class Users::ThemesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_visitor) # 最低権限のユーザでも操作可能
    login_as(@user)
  end

  test "画面テーマ変更(表示)" do
    get new_users_theme_path
    assert_response :success
  end

  test "画面テーマ変更(実行)" do
    user = { theme: :dark }
    assert_no_difference('User.count') do
      post users_themes_path, params: {user: user}
    end
    assert_redirected_to menu_index_path

    @user.reload
    assert_equal user[:theme], @user.theme.to_sym
  end
end
