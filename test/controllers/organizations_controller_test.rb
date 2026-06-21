require 'test_helper'

class OrganizationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @organization = Organization.first
  end

  test "管理マスタ変更画面表示" do
    get edit_organization_path(@organization)
    assert_response :success
  end

  test "管理マスタ変更(システム管理者以外)" do
    login_as(users(:user_manager))
    get edit_organization_path(@organization)
    assert_response :error
  end

  test "管理マスタ変更実行" do
    organization_name = "テスト営農組合"
    account_number = "2345678"
    assert_no_difference('Organization.count') do
      patch organization_path(@organization), params: { organization: { name: organization_name, account_number: account_number } }
    end
    assert_redirected_to menu_index_path

    @organization.reload
    assert_equal organization_name, @organization.name
    assert_equal account_number, @organization.account_number
  end
end
