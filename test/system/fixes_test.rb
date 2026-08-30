require "application_system_test_case"

class FixesTest < ApplicationSystemTestCase
  ORIGINAL_SUM_MACHINES_AMOUNT = Work.instance_method(:sum_machines_amount)

  setup do
    @user = users(:users1)
  end

  teardown do
    Work.define_method(:sum_machines_amount, ORIGINAL_SUM_MACHINES_AMOUNT)
  end

  test "新規確定で機械使用料がカンマ区切りのまま表示され、選択時の合計も正しく計算される" do
    work1 = works(:work_no_fix1)
    work2 = works(:work_no_fix2)
    amounts = { work1.id => BigDecimal("5250"), work2.id => BigDecimal("3400") }
    Work.define_method(:sum_machines_amount) { amounts.fetch(id, 0) }

    login_as(@user)
    visit new_fix_path

    assert_selector "#machine_#{work1.id}", text: "5,250"
    assert_selector "#machine_#{work2.id}", text: "3,400"
    assert_selector "#total_machine", text: "0"

    click_on "全選択", match: :first

    assert_selector "#total_machine", text: "8,650"

    click_on "全解除", match: :first

    assert_selector "#total_machine", text: "0"
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
