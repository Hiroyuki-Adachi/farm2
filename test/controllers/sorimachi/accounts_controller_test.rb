require "test_helper"

class Sorimachi::AccountsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "ソリマチ科目初期化" do
    assert_difference('SorimachiAccount.count', sorimachi_accounts.count - 1) do
      post :create
    end
    assert_redirected_to sorimachi_accounts_path
  end

  test "ソリマチ科目一覧" do
    get :index
    assert_response :success
  end

  test "ソリマチ科目編集(表示)" do
    journal = sorimachi_journals(:journal1)
    get :edit, params: {code: journal.code01}
    assert_response :success
  end

  test "ソリマチ科目編集(更新)" do
    account = sorimachi_accounts(:sorimachi_accounts_2015)
    assert_no_difference('SorimachiAccount.count') do
      put :update, params: {
        code: account.code, 
        sorimachi_account: {name: 'TEST', cost_flag: true}
      }
    end
    assert_redirected_to sorimachi_accounts_path

    journal = sorimachi_journals(:journal1)
    assert_difference('SorimachiAccount.count') do
      put :update, params: {
        code: journal.code01, 
        sorimachi_account: {code: journal.code01, name: 'TEST', cost_flag: true}
      }
    end
    assert_redirected_to sorimachi_accounts_path
  end

  test "ソリマチ科目削除" do
    account = sorimachi_accounts(:sorimachi_accounts_2015)
    assert_difference('SorimachiAccount.count', -1) do
      delete :destroy, params: {code: account.code}
    end
    assert_redirected_to sorimachi_accounts_path
  end
end
