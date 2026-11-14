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

  test "LINEチャネル設定を登録できる" do
    patch organization_path(@organization), params: { organization: {
      line_channel_id: "1234567890", line_channel_access_token: "token", line_channel_secret: "secret"
    } }
    assert_redirected_to menu_index_path

    @organization.reload
    assert_equal "1234567890", @organization.line_channel_id
    assert_equal "token", @organization.line_channel_access_token
    assert_equal "secret", @organization.line_channel_secret
  end

  test "LINEのアクセストークン・シークレットは画面に表示せず空欄なら変更しない" do
    @organization.update!(line_channel_id: "1234567890", line_channel_access_token: "access-token-1242",
                          line_channel_secret: "channel-secret-1242")

    get edit_organization_path(@organization)
    assert_response :success
    assert_not_includes response.body, "access-token-1242"
    assert_not_includes response.body, "channel-secret-1242"
    assert_select "input#organization_line_channel_access_token:not([value])"
    assert_select "input#organization_line_channel_secret:not([value])"

    patch organization_path(@organization), params: { organization: {
      line_channel_id: "9876543210", line_channel_access_token: "", line_channel_secret: ""
    } }

    @organization.reload
    assert_equal "9876543210", @organization.line_channel_id
    assert_equal "access-token-1242", @organization.line_channel_access_token
    assert_equal "channel-secret-1242", @organization.line_channel_secret
  end

  test "LINEチャネル設定を削除できる" do
    @organization.update!(line_channel_id: "1234567890", line_channel_access_token: "token",
                          line_channel_secret: "secret")

    patch organization_path(@organization), params: {
      organization: { line_channel_id: "1234567890", line_channel_access_token: "", line_channel_secret: "" },
      clear_line_channel: "1"
    }

    @organization.reload
    assert_nil @organization.line_channel_id
    assert_nil @organization.line_channel_access_token
    assert_nil @organization.line_channel_secret
  end
end
