require "application_system_test_case"

class BankBranchLookupTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @worker = workers(:worker1)
    Bank.create!(code: "0001", name: "みずほ銀行", kana: "ミズホギンコウ")
      .bank_branches.create!(code: "001", name: "東京営業部", kana: "トウキヨウエイギヨウブ")
  end

  test "作業者編集画面で銀行コード・支店コードから名称が表示される" do
    login

    visit edit_worker_path(@worker)

    fill_in "worker_bank_code", with: "0001"
    fill_in "worker_branch_code", with: "001"

    assert_selector "#bank_code_name", text: "みずほ銀行"
    assert_selector "#branch_code_name", text: "東京営業部"
  end

  test "該当しないコードの場合は名称が表示されない" do
    login

    visit edit_worker_path(@worker)

    fill_in "worker_bank_code", with: "0001"
    assert_selector "#bank_code_name", text: "みずほ銀行"

    fill_in "worker_bank_code", with: "9999"
    assert_no_selector "#bank_code_name", text: "みずほ銀行"
  end

  test "管理情報変更画面でも銀行コード・支店コードから名称が表示される" do
    login

    visit edit_organization_path(organizations(:org))

    fill_in "organization_bank_code", with: "0001"
    fill_in "organization_branch_code", with: "001"

    assert_selector "#bank_code_name", text: "みずほ銀行"
    assert_selector "#branch_code_name", text: "東京営業部"
  end

  private

  def login
    visit root_path
    fill_in "login_name", with: @user.login_name
    fill_in "password", with: "password"
    click_button "認証する"
    assert_selector "a", text: "作業日報管理"
  end
end
