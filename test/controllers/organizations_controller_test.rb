require 'test_helper'

class OrganizationsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @organization = Organization.first
  end

  test "管理マスタ変更画面表示" do
    get :edit, id: @organization
    assert_response :success
  end

  test "管理マスタ変更実行" do
    assert_no_difference('Organization.count') do
      patch :update, id: @organization, organization: { name: "テスト営農組合" }
    end
    assert_redirected_to menu_index_path
  end
end
