require "application_system_test_case"

class WorkersTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ログインから作業者保守" do
    visit root_path
    assert_selector 'body'

    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'

    visit workers_path
    assert_selector 'h1', text: '作業者マスタ一覧'

    click_link '次'
    assert_current_path workers_path(page: 2), ignore_query: false

    within 'tbody tr:first-child' do
      click_link '修正'
    end
    assert_selector 'h1', text: '作業者マスタ修正'

    fill_in 'worker_mobile', with: '090-0000-0000'
    click_button '登録'

    assert_current_path workers_path(page: 2), ignore_query: false
    assert_selector 'h1', text: '作業者マスタ一覧'
    assert_selector 'tbody', text: '090-0000-0000'
  end
end
