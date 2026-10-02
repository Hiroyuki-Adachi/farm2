require "application_system_test_case"

class MachineReserveFundDetailsTest < ApplicationSystemTestCase
  setup do
    @fund = MachineReserveFund.create!(organization: organizations(:org), machine: machines(:machines1),
                                       started_on: Date.new(2015, 7, 15), years: 2,
                                       total_amount: 240_000, remaining_amount: 240_000)
    type = work_types(:work_types1)
    WorkTypeTerm.find_or_create_by!(work_type: type, term: 2015)
    LandCost.create!(land: lands(:lands0), work_type: type, activated_on: Date.new(2015, 1, 1))
    visit root_path
    fill_in "login_name", with: users(:users1).login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", exact_text: "作業日報管理"
  end

  test "初期月割額を確認して上書き登録し明細と原価を削除できる" do
    ensure_sidebar_shown!
    click_link "原価管理"
    within("#sidebar_desktop") { click_link "基盤強化準備金明細" }
    assert_selector "h1", text: "基盤強化準備金明細一覧"
    within("tr", text: @fund.machine.alias_name) { click_link "登録" }
    assert_field "原価額", with: "60000"
    fill_in "原価額", with: "12345"
    click_button "登録"
    assert_current_path machine_reserve_fund_details_path
    assert_text "登録済"
    assert_text "12,345"
    detail = @fund.machine_reserve_fund_details.sole
    assert_equal 12_345, detail.machine_reserve_fund_costs.sum(:cost)
    click_link "削除"
    within("#popup_confirm") { click_button "はい" }
    assert_text "未登録"
    assert_not MachineReserveFundDetail.exists?(detail.id)
    assert_not MachineReserveFundCost.exists?(machine_reserve_fund_detail_id: detail.id)
  end
end
