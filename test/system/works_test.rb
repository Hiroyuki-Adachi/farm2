require "application_system_test_case"

class WorksTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ログインから日報入力まで" do
    visit root_path 
    assert_selector 'body'

    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'

    ensure_sidebar_shown!

    click_link '日報入力'
    assert_selector 'h1', exact_text: '作業日報入力'

    fill_in 'work_worked_at', with: Date.new(2015, 5, 5)
    select '曇り', from: 'work[weather_id]'
    fill_in 'work_start_at', with: '0900'
    fill_in 'work_end_at', with: '1500'
    choose 'work_type_23'
    select '代掻', from: 'work[work_kind_id]'
    fill_in 'work_name', with: '作業の内容'
    fill_in 'work_remarks', with: '作業の記事ですよーーー'

    assert_difference 'Work.count', 1 do
      click_button '登録'
    end
    assert_selector 'h1', exact_text: '作業日報(作業者)登録'

    assert_difference 'WorkResult.count', 1 do
      click_button 'add_button_1'
      click_button '登録'
    end
    assert_selector 'h1', exact_text: '作業日報(健康)登録'

    click_button '登録'
    assert_selector 'table#detail_workers', text: '後藤 晴美'

    find('#cover_lands').click
    assert_selector 'h1', exact_text: '作業日報(作業田)登録'

    fill_in 'land', with: '538'
    assert_selector '[id^="autoComplete_list_"]', wait: 5

    find('#autoComplete_result_0').click
    assert_difference 'WorkLand.count', 1 do
      click_button '登録'
    end
  end
end
