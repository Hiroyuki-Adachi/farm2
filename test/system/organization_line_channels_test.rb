require "application_system_test_case"

class OrganizationLineChannelsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @organization = organizations(:org)
  end

  test "管理情報変更画面でLINEチャネル設定を登録・削除できる" do
    login

    visit edit_organization_path(@organization)
    assert_no_selector "#clear_line_channel"
    fill_in "organization_line_channel_id", with: "1234567890"
    fill_in "organization_line_channel_access_token", with: "token"
    fill_in "organization_line_channel_secret", with: "secret"
    click_button "登録"
    assert_selector "a", text: "作業日報管理"

    @organization.reload
    assert_equal "1234567890", @organization.line_channel_id
    assert_equal "token", @organization.line_channel_access_token
    assert_equal "secret", @organization.line_channel_secret

    visit edit_organization_path(@organization)
    assert_field "organization_line_channel_id", with: "1234567890"
    assert_field "organization_line_channel_access_token", with: "", placeholder: "設定済み(変更時のみ入力)"
    check "clear_line_channel"
    click_button "登録"
    assert_selector "a", text: "作業日報管理"

    @organization.reload
    assert_nil @organization.line_channel_id
    assert_nil @organization.line_channel_access_token
    assert_nil @organization.line_channel_secret
  end

  private

  def login
    visit root_path
    fill_in "login_name", with: @user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", text: "作業日報管理"
  end
end
