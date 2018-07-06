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
    patch :create, params: {user_id: @user, user: { permission_id: Permission::MANAGER.id }}
    assert_redirected_to users_path
  end
end
