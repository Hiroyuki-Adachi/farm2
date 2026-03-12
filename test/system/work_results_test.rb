require "application_system_test_case"

class WorkResultsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @worker = workers(:worker1)
  end

  test "ログインから日当一覧まで" do
    visit root_path 
    assert_selector 'body'

    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'

    visit work_results_path
    assert_selector 'h1', text: '世帯別日当一覧'

    # ここから日当一覧の動作確認
    # 最初は全て閉じている
    assert_selector 'table[data-controller="grouped-rows"]'
    within_table do
      expect_all_hidden ".tr-total2"
      expect_all_hidden ".tr-detail"
    end

    # 世帯の合計を開閉
    within_table do
      total1 = find("tr.tr-total1[data-code1=\"#{@worker.home_id}\"]", visible: :all)
      total1.click
      expect_all_visible ".tr-total2[data-code1=\"#{@worker.home_id}\"]"
      expect_all_hidden  ".tr-detail[data-code1=\"#{@worker.home_id}\"]"

      total1.click
      expect_all_hidden ".tr-total2[data-code1=\"#{@worker.home_id}\"]"
      expect_all_hidden ".tr-detail[data-code1=\"#{@worker.home_id}\"]"
    end

    # 世帯の小計を開閉
    within_table do
      # まず合計クリックで小計を出す（仕様どおり）
      find("tr.tr-total1[data-code1=\"#{@worker.home_id}\"]", visible: :all).click

      subtotal = find("tr.tr-total2[data-code1=\"#{@worker.home_id}\"][data-code2=\"#{@worker.id}\"]", visible: :all)
      subtotal.click
      expect_all_visible ".tr-detail[data-code1=\"#{@worker.home_id}\"][data-code2=\"#{@worker.id}\"]"

      subtotal.click
      expect_all_hidden ".tr-detail[data-code1=\"#{@worker.home_id}\"][data-code2=\"#{@worker.id}\"]"
    end
  end

  private

  def within_table(&blk)
    within('table[data-controller="grouped-rows"]', &blk)
  end

  def expect_all_hidden(selector)
    els = page.all(selector, visible: :all)
    # 要素が存在しない場合は “存在しない＝隠れている” と誤判定しないため存在チェック
    assert els.any?, "期待した要素が見つかりません: #{selector}"
    assert els.all? { |el| !el.visible? }, "少なくとも1つ可視: #{selector}"
  end

  def expect_all_visible(selector)
    els = page.all(selector, visible: :all)
    assert els.any?, "期待した要素が見つかりません: #{selector}"
    assert els.all?(&:visible?), "少なくとも1つ非表示: #{selector}"
  end
end