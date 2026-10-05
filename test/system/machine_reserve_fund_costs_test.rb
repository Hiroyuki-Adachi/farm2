require "application_system_test_case"

class MachineReserveFundCostsTest < ApplicationSystemTestCase
  setup do
    @types = [work_types(:work_types1), work_types(:work_types2)]
    @types.each { |type| WorkTypeTerm.find_or_create_by!(work_type: type, term: 2015) }
    LandCost.delete_all
    land = lands(:lands0)
    land.update!(area: 10, start_on: Date.new(2015, 1, 1), end_on: Date.new(2015, 12, 31))
    LandCost.create!(land: land, work_type: @types.first, activated_on: Date.new(2015, 1, 1))
    LandCost.create!(land: land, work_type: @types.last, activated_on: Date.new(2015, 7, 1))
    @fund = create_fund(machines(:machines1), Date.new(2015, 1, 1))
    @detail = @fund.build_detail(systems(:s2015))
    @detail.amount = 36_500
    assert @detail.register(systems(:s2015))
    visit root_path
    fill_in "login_name", with: users(:users1).login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", exact_text: "作業日報管理"
  end

  test "明細から原価編集し合計エラーを修正して再按分できる" do
    visit machine_reserve_fund_details_path
    within("tr", text: @fund.machine.alias_name) { click_link "原価" }
    assert_selector "h1", text: "基盤強化準備金原価編集"
    assert_field @types.first.name, with: "18100"
    fill_in @types.first.name, with: "18000"
    assert_selector "[data-reserve-fund-cost-total-target='total']", text: "36,400"
    click_button "登録"
    assert_text "合計は原価額と一致"
    assert_field @types.first.name, with: "18000"
    assert_equal 18_100, @detail.machine_reserve_fund_costs.find_by!(work_type: @types.first).cost
    fill_in @types.last.name, with: "18500"
    click_button "登録"
    assert_current_path machine_reserve_fund_costs_path
    assert_equal 18_000, @detail.machine_reserve_fund_costs.find_by!(work_type: @types.first).cost
    click_link "変更"
    click_button "再按分"
    assert_text "再按分しました"
    assert_field @types.first.name, with: "18100"
    assert_field @types.last.name, with: "18400"
    assert_equal 36_500, @detail.machine_reserve_fund_costs.sum(:cost)
    assert_equal 36_500, @detail.reload.amount
    assert_equal 83_500, @detail.remaining_amount
  end

  test "原価管理メニューから機械横断マトリクスと縦計を確認できる" do
    second_fund = create_fund(machines(:machines2), Date.new(2015, 2, 1))
    second = second_fund.build_detail(systems(:s2015))
    second.amount = 36_500
    assert second.register(systems(:s2015))
    ensure_sidebar_shown!
    click_link "原価管理"
    within("#sidebar_desktop") { click_link "基盤強化準備金原価一覧" }
    assert_selector "h1", text: "基盤強化準備金原価一覧"
    assert_selector "thead th", text: @types.first.name
    assert_selector "tbody tr", count: 2
    # 機械表示順を開始年月より優先する。
    assert_selector "tbody tr:first-child", text: second_fund.machine.alias_name
    within("tfoot") do
      assert_text "36,200"
      assert_text "36,800"
      assert_text "73,000"
    end
  end

  test "明細登録後は機械の総額を編集できない" do
    visit edit_machine_reserve_fund_path(@fund)
    assert_selector "input[name='machine_reserve_fund[total_amount]'][readonly]"
    assert_no_link "削除"
  end

  private

  def create_fund(machine, started_on)
    MachineReserveFund.create!(organization: organizations(:org), machine: machine, started_on: started_on,
                               years: 1, total_amount: 120_000, remaining_amount: 120_000)
  end
end
