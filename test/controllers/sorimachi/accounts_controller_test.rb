require "test_helper"

class Sorimachi::AccountsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "ソリマチ科目初期化" do
    assert_difference('SorimachiAccount.count', sorimachi_accounts.count - 1) do
      post sorimachi_accounts_path
    end
    assert_redirected_to sorimachi_accounts_path
  end

  test "ソリマチ科目一覧" do
    get sorimachi_accounts_path
    assert_response :success
  end

  test "ソリマチ科目編集(表示)" do
    journal = sorimachi_journals(:journal1)
    get edit_sorimachi_account_path(code: journal.code01)
    assert_response :success
  end

  test "ソリマチ科目編集(勘定科目)" do
    account = sorimachi_accounts(:sorimachi_accounts_2015)
    sorimachi_account = {name: 'TEST', cost_flag: true}
    assert_no_difference('SorimachiAccount.count') do
      put sorimachi_account_path(code: account.code), params: {
        sorimachi_account: sorimachi_account
      }
    end
    assert_redirected_to sorimachi_accounts_path

    account.reload
    assert_equal sorimachi_account[:name], account.name
  end

  test "ソリマチ科目編集(仕訳)" do
    journal = sorimachi_journals(:journal1)
    sorimachi_account = {code: journal.code01, name: 'TEST', cost_flag: true}
    assert_difference('SorimachiAccount.count') do
      put sorimachi_account_path(code: journal.code01), params: {
        sorimachi_account: sorimachi_account
      }
    end
    assert_redirected_to sorimachi_accounts_path

    created_account = SorimachiAccount.last
    assert_equal sorimachi_account[:name], created_account.name
    assert_equal sorimachi_account[:code], created_account.code
    assert_equal @user.term, created_account.term
  end

  test "ソリマチ科目削除" do
    account = sorimachi_accounts(:sorimachi_accounts_2015)
    assert_difference('SorimachiAccount.count', -1) do
      delete sorimachi_account_path(code: account.code)
    end
    assert_redirected_to sorimachi_accounts_path

    assert_nil SorimachiAccount.find_by(code: account.code, term: @user.term)
  end
end
