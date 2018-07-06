require 'test_helper'

class BanksControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @bank = Bank.new(code: "0003", name: "JA□□", phonetic: "ｼｶｸﾉｳｷﾞﾖｳｷﾖｳﾄﾞｳｸﾐｱｲ")
  end

  test "銀行マスタ一覧" do
    get :index
    assert_response :success
    assert_not_nil assigns(:banks)
  end

  test "銀行マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "銀行マスタ新規作成(実行)" do
    assert_difference('Bank.count') do
      post :create, params: {bank: {code: @bank.code, name: @bank.name, phonetic: @bank.phonetic}}
    end

    assert_redirected_to banks_path
  end

  test "銀行マスタ変更(表示)" do
    get :edit, params: {code: "0002"}
    assert_response :success
  end

  test "銀行マスタ変更(実行)" do
    assert_no_difference('Bank.count') do
      patch :update, params: {code: "0002", bank: {code: "0002", name: @bank.name, phonetic: @bank.phonetic}}
    end
    assert_redirected_to banks_path
  end

  test "銀行マスタ削除" do
    assert_difference('Bank.count', -1) do
      delete :destroy, params: {code: "0001"}
    end

    assert_redirected_to banks_path
  end
end
