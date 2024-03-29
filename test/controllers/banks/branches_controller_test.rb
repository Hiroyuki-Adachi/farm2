require 'test_helper'

class Banks::BranchesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @update = {code: "999", name: "東支店", phonetic: "ﾋｶﾞｼ"}
  end

  test "支店マスタ一覧" do
    get :index, params: {bank_code: bank_branches(:branch1_2).bank_code}
    assert_response :success
  end

  test "支店マスタ新規作成(表示)" do
    get :new, params: {bank_code: bank_branches(:branch1_2).bank_code}
    assert_response :success
  end

  test "支店マスタ新規作成(実行)" do
    assert_difference('BankBranch.count') do
      post :create, params: {bank_code: bank_branches(:branch1_2).bank_code, bank_branch: @update}
    end

    assert_redirected_to bank_branches_path(bank_code: bank_branches(:branch1_2).bank_code)
  end

  test "支店マスタ変更(表示)" do
    get :edit, params: {bank_code: bank_branches(:branch1_2).bank_code, code: bank_branches(:branch1_2).code}
    assert_response :success
  end

  test "支店マスタ変更(実行)" do
    assert_no_difference('BankBranch.count') do
      patch :update, params: {bank_code: bank_branches(:branch1_2).bank_code, code: bank_branches(:branch1_2).code, bank_branch: @update}
    end
    assert_redirected_to bank_branches_path(bank_code: bank_branches(:branch1_2).bank_code)
  end

  test "支店マスタ削除" do
    assert_difference('BankBranch.count', -1) do
      delete :destroy, params: {bank_code: bank_branches(:branch1_2).bank_code, code: bank_branches(:branch1_2).code}
    end
    assert_redirected_to bank_branches_path(bank_code: bank_branches(:branch1_2).bank_code)
  end
end
