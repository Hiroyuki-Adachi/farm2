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

  test "金額ゼロの明細はハイライト表示されCSV出力ボタンに確定日が引き継がれる" do
    fixed_at = Date.new(2015, 2, 28)
    zero_result = WorkResult.for_organization(@user.organization).by_home(@user.term)
      .find_by(worker_id: @worker.id)
    zero_result.work.update!(fixed_at: fixed_at)
    zero_result.work.work_results.each do |r|
      r.update!(fixed_hours: r.hours, fixed_price: 1000, fixed_amount: 1000 * r.hours)
    end
    zero_result.reload.update!(fixed_price: 0, fixed_amount: 0)

    login
    visit work_results_path(fixed_at: "2015-02-28")
    assert_selector 'h1', text: '世帯別日当一覧'

    within_table do
      find("tr.tr-total1[data-code1=\"#{@worker.home_id}\"]").click
      find("tr.tr-total2[data-code1=\"#{@worker.home_id}\"][data-code2=\"#{@worker.id}\"]").click
      assert_selector "tr.tr-detail.table-warning[data-code2=\"#{@worker.id}\"]", count: 1
    end

    assert_selector "a[href=\"#{work_results_path(fixed_at: '2015-02-28', format: :csv)}\"]", text: 'CSV出力'
  end

  private

  def login
    visit root_path
    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'
  end

  def within_table(&)
    within('table[data-controller="grouped-rows"]', &)
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
