require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ログインからログアウトまで" do
    visit root_path 
    assert_selector '#login_name'

    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', text: '作業日報管理'

    click_link 'ログアウト'
    assert_selector '#login_name'
  end
end
