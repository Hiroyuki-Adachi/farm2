require 'test_helper'

class BanksControllerTest < ActionController::TestCase
  fixtures :banks

  setup do
    @bank = Bank.new(code: "0003", name: "JA□□", phonetic: "ｼｶｸﾉｳｷﾞﾖｳｷﾖｳﾄﾞｳｸﾐｱｲ")
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:banks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create bank" do
    assert_difference('Bank.count') do
      post :create, bank: { code: @bank.code, name: @bank.name, phonetic: @bank.phonetic }
    end

    assert_redirected_to banks_path
  end

  test "should get edit" do
    get :edit, code: "0002"
    assert_response :success
  end

  test "should update bank" do
    patch :update, code: "0002", bank: { code: "0002", name: @bank.name, phonetic: @bank.phonetic }
    assert_redirected_to banks_path
  end

  test "should destroy bank" do
    assert_difference('Bank.count', -1) do
      delete :destroy, code: "0001"
    end

    assert_redirected_to banks_path
  end
end
