require "application_system_test_case"

class StatisticsGraphTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ログインから統計グラフ表示まで" do
    visit root_path

    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', text: '作業日報管理'

    visit statistics_path
    assert_selector 'h1', text: '統計情報一覧'

    canvas = find("canvas#chart")
    assert canvas.present?
    default_width = canvas[:width].to_i
    default_height = canvas[:height].to_i
    assert_not page.evaluate_script("!!window.myChart")

    ensure_sidebar_shown!
    click_link '全作業時間', wait: 10
    assert canvas[:width].to_i > default_width
    assert canvas[:height].to_i > default_height
    assert page.evaluate_script("!!window.myChart")

    click_link '作業種別別時間', wait: 10
    assert canvas[:width].to_i > default_width
    assert canvas[:height].to_i > default_height
    assert page.evaluate_script("!!window.myChart")

    click_link '世代別時間', wait: 10
    assert canvas[:width].to_i > default_width
    assert canvas[:height].to_i > default_height
    assert page.evaluate_script("!!window.myChart")

    click_link '月別作業時間', wait: 10
    assert canvas[:width].to_i > default_width
    assert canvas[:height].to_i > default_height
    assert page.evaluate_script("!!window.myChart")
  end
end
