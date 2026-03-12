# test/system/statistics_graph_test.rb
require "application_system_test_case"

class StatisticsGraphTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ログイン後、各統計タブでグラフが描画される（描画済みフラグで判定）" do
    # ログイン
    visit root_path
    fill_in "login_name", with: @user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", text: "作業日報管理"

    # 統計ページへ
    visit statistics_path
    assert_selector "h1", text: "統計情報一覧"

    # Canvas があることだけ最初に確認
    assert_selector "canvas#chart[data-chart-rendered]", wait: 5

    # タブを順にクリックして、描画済みフラグ=1 を待つ
    %w[全作業時間 作業種別別時間 世代別時間 月別作業時間].each do |label|
      click_tab_and_expect_render(label)
    end
  end

  private

  def click_tab_and_expect_render(label)
    ensure_sidebar_shown! if respond_to?(:ensure_sidebar_shown!)
    click_link label

    # “描画済みっぽい” フラグだけを検証（Chart のグローバル不要）
    assert_selector "canvas#chart[data-chart-rendered='1']", wait: 5
  end
end
