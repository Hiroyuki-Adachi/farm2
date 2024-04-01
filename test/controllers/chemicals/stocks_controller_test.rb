require "test_helper"

class Chemicals::StocksControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @chemical_term = chemical_terms(:chemical_term_3_2015)
    @stock = chemical_stocks(:stock_edit)
  end

  test "農薬在庫一覧" do
    get :index
    assert_response :success
  end

  test "農薬在庫一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "農薬在庫(AJAX)" do
    get :load, params: {term: 2015, chemical_type_id: 3}
    assert_response :success
  end

  test "農薬在庫検索" do
    get :search, params: {chemical_id: @chemical_term.id}
    assert_response :success
  end

  test "農薬在庫新規作成(表示)" do
    get :new, params: {chemical_id: @chemical_term.id}
    assert_response :success
  end

  test "農薬在庫新規作成(実行)" do
    assert_difference('ChemicalStock.count') do
      post :create, params: {
        chemical_id: @chemical_term.id, 
        chemical_stock: {
          stock_on: '2015-03-03',
          name: 'TEST',
          stored: 20
        }}
    end
    assert_response :success
  end

  test "農薬在庫編集(表示)" do
    get :edit, params: {chemical_id: @chemical_term.id, id: @stock.id}
    assert_response :success
  end

  test "農薬在庫編集(実行)" do
    assert_no_difference('ChemicalStock.count') do
      post :update, params: {
        chemical_id: @chemical_term.id, 
        id: @stock.id,
        chemical_stock: {
          stock_on: '2015-12-31',
          name: 'UPDATE',
          stored: 1
        }}
    end
    assert_response :success
    assert_equal 1, ChemicalStock.find(@stock.id).stored
  end

  test "農薬在庫削除(実行)" do
    assert_difference('ChemicalStock.count', -1) do
      delete :destroy, params: {
        chemical_id: @chemical_term.id, 
        id: @stock.id
      }
    end
    assert_response :success
  end
end
