require "application_system_test_case"

class MenuTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ログインから各メニューの表示" do
    visit root_path 

    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', text: '作業日報管理'

    ensure_wide!
    menu_ids = all("li.nav-item > a.nav-link.farm2-navi").map { |menu| menu[:id] }

    menu_ids.each do |menu_id|
      find("##{menu_id}").click

      assert_selector("#menu_dropdown", visible: true)
      menu_dropdown = find("#menu_dropdown", visible: true)
      assert_includes menu_dropdown[:style], "display: block"
      assert_equal menu_id, menu_dropdown[:'data-id']
    end
  end
end
