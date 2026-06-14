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
    user = { permission_id: :manager }
    assert_no_difference('User.count') do
      post user_permissions_path(user_id: @user.id), params: { user: user }
    end
    assert_redirected_to users_path

    @user.reload
    assert_equal user[:permission_id], @user.permission_id.to_sym
  end

  test "他組織ユーザの権限変更画面は表示しない" do
    get new_user_permission_path(user_id: users(:user_admin_org2).id)

    assert_response :service_unavailable
  end

  test "他組織ユーザの権限は変更しない" do
    other_user = users(:user_admin_org2)

    assert_no_changes -> { other_user.reload.permission_id } do
      post user_permissions_path(user_id: other_user.id), params: { user: { permission_id: :manager } }
    end
    assert_response :service_unavailable
  end
end
