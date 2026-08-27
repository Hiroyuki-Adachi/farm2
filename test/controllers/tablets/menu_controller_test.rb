require "test_helper"

class Tablets::MenuControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "ログアウトリンクはTurboプリフェッチを無効にする" do
    get tablets_menu_index_path

    assert_response :success
    assert_select %(a[href="#{new_tablets_session_path}"][data-turbo-prefetch="false"]) do |links|
      assert_includes links.first.text, "ログアウト"
    end
  end
end
