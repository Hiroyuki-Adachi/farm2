require 'test_helper'

class Users::PermissionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "権限変更(表示)" do
    get new_user_permission_path(user_id: @user.id)
    assert_response :success
  end

  test "権限変更(実行)" do
    user = { permission: :manager }
    assert_no_difference('User.count') do
      post user_permissions_path(user_id: @user.id), params: {user: user}
    end
    assert_redirected_to users_path

    @user.reload
    assert_equal user[:permission], @user.permission.to_sym
  end
end
