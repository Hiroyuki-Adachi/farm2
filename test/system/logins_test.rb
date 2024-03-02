require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
  test "ログインからログアウトまで" do
    visit root_path 
    assert_selector '#login_name'

    fill_in 'login_name', with: '1234567890'
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', text: '作業日報管理'

    click_link 'ログアウト'
    assert_selector '#login_name'
  end
end
