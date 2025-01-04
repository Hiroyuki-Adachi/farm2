require 'test_helper'

class Users::PermissionsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
  end

  test "権限変更(表示)" do
    get :new, params: {user_id: @user.id}
    assert_response :success
  end

  test "権限変更(実行)" do
    assert_no_difference('User.count') do
      patch :create, params: {user_id: @user, user: { permission_id: Permission::MANAGER.id }}
    end
    assert_redirected_to users_path

    new_user = User.find(@user.id)
    assert_equal Permission::MANAGER.id, new_user.permission_id
  end
end
