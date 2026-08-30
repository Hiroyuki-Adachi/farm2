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

  test "管理可能な利用者には作付予定リンクを表示する" do
    get tablets_menu_index_path

    assert_response :success
    assert_select %(a[href="#{new_tablets_plans_work_type_path}"]), text: /作付予定/
    assert_select %(a[href="#{new_tablets_plans_land_path}"]), text: /作付計画/
  end

  test "管理者以外には作付予定リンクを表示しない" do
    login_as(users(:user_checker))

    get tablets_menu_index_path

    assert_response :success
    assert_select %(a[href="#{new_tablets_plans_work_type_path}"]), count: 0
    assert_select %(a[href="#{new_tablets_plans_land_path}"]), count: 0
  end
end
