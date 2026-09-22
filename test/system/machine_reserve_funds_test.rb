require "application_system_test_case"

class MachineReserveFundsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @machine = machines(:machines1)
  end

  test "サイドバーから基盤強化準備金原価画面へ遷移できる" do
    login_as(@user)
    ensure_sidebar_shown!
    click_link "原価管理"

    within "#sidebar_desktop" do
      click_link "基盤強化準備金原価"
    end

    assert_selector "h1", text: "基盤強化準備金データ一覧"
  end

  test "登録前は一覧に表示されず、登録済みの機械だけが表示される" do
    login_as(@user)
    visit machine_reserve_funds_path

    assert_no_text @machine.alias_name

    MachineReserveFund.create!(
      organization: organizations(:org), machine: @machine,
      started_on: Date.new(2025, 4, 1), years: 7, total_amount: 1_000_000
    )
    visit machine_reserve_funds_path

    assert_text @machine.alias_name
  end

  test "一覧は開始年月順に並び、金額は右詰めで表示される" do
    older_machine = machines(:machines2)
    MachineReserveFund.create!(
      organization: organizations(:org), machine: @machine,
      started_on: Date.new(2025, 4, 1), years: 7, total_amount: 1_000_000
    )
    MachineReserveFund.create!(
      organization: organizations(:org), machine: older_machine,
      started_on: Date.new(2024, 4, 1), years: 7, total_amount: 2_000_000
    )

    login_as(@user)
    visit machine_reserve_funds_path

    machine_cells = all("td:nth-child(2)").map(&:text)
    assert_equal [older_machine.alias_name, @machine.alias_name], machine_cells

    assert_selector "td.text-end", text: "1,000,000"
    assert_selector "td.text-end", text: "2,000,000"
  end

  test "機種から機械を選んで新規登録すると一覧に反映される" do
    login_as(@user)
    visit new_machine_reserve_fund_path

    select @machine.machine_type.name, from: "machine_type_id"
    assert_selector "#machine_id option", text: @machine.usual_name, wait: 5
    select @machine.usual_name, from: "machine_id"
    fill_in "machine_reserve_fund_started_on", with: "2025-04-01"
    fill_in "machine_reserve_fund_years", with: "7"
    fill_in "machine_reserve_fund_total_amount", with: "3500000"
    click_button "登録"

    assert_current_path machine_reserve_funds_path
    within "tr", text: @machine.alias_name do
      assert_text "2025-04"
      assert_text "3,500,000"
    end

    reserve_fund = MachineReserveFund.find_by(machine_id: @machine.id)
    assert_equal 3_500_000, reserve_fund.total_amount
  end

  test "登録済み明細の合計額より総額を小さくできず、削除ボタンも表示されない" do
    reserve_fund = MachineReserveFund.create!(
      organization: organizations(:org), machine: @machine,
      started_on: Date.new(2025, 4, 1), years: 7, total_amount: 1_000_000
    )
    MachineReserveFundDetail.create!(
      organization: organizations(:org), machine_reserve_fund: reserve_fund,
      term: 2025, months: 12, amount: 400_000, remaining_amount: 600_000
    )

    login_as(@user)
    visit edit_machine_reserve_fund_path(reserve_fund)

    assert_no_link "削除"

    fill_in "machine_reserve_fund_total_amount", with: "300000"
    click_button "登録"

    assert_selector ".alert-danger", text: "登録済みの原価額より小さくできません"
    assert_equal 1_000_000, reserve_fund.reload.total_amount
  end

  private

  def login_as(user)
    visit root_path
    fill_in "login_name", with: user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", exact_text: "作業日報管理"
  end
end
