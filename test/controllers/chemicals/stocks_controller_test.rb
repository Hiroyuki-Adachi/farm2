require "test_helper"

class Chemicals::StocksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @chemical_term = chemical_terms(:chemical_term_3_2015)
    @stock = chemical_stocks(:stock_edit)
  end

  test "農薬在庫一覧" do
    get chemicals_stocks_path
    assert_response :success
  end

  test "農薬在庫一覧(管理者以外)" do
    login_as(users(:user_checker))
    get chemicals_stocks_path
    assert_response :error
  end

  test "農薬在庫(AJAX)" do
    get load_chemicals_stocks_path, params: {term: 2015, chemical_type_id: 3}
    assert_response :success
  end

  test "農薬在庫検索" do
    get search_chemical_stocks_path(chemical_id: @chemical_term.id)
    assert_response :success
  end

  test "農薬在庫新規作成(表示)" do
    get new_chemical_stock_path(chemical_id: @chemical_term.id)
    assert_response :success
  end

  test "農薬在庫新規作成(実行)" do
    chemical_stock = {
      stock_on: '2015-03-03',
      name: 'TEST',
      stored: 20
    }
    assert_difference('ChemicalStock.count') do
      post chemical_stocks_path(chemical_id: @chemical_term.id), params: {
        chemical_stock: chemical_stock
      }
    end
    assert_response :success

    created_checmical_stock = ChemicalStock.last
    assert_equal chemical_stock[:stock_on], created_checmical_stock.stock_on.to_s
    assert_equal chemical_stock[:name], created_checmical_stock.name
    assert_equal chemical_stock[:stored], created_checmical_stock.stored
  end

  test "農薬在庫編集(表示)" do
    get edit_chemical_stock_path(chemical_id: @chemical_term.id, id: @stock.id)
    assert_response :success
  end

  test "農薬在庫編集(実行)" do
    chemical_stock = {
      stock_on: '2015-12-31',
      name: 'UPDATE',
      stored: 1
    }
    assert_no_difference('ChemicalStock.count') do
      patch chemical_stock_path(chemical_id: @chemical_term.id, id: @stock.id), params: {
        chemical_stock: chemical_stock
      }
    end
    assert_response :success

    @stock.reload
    assert_equal chemical_stock[:stock_on], @stock.stock_on.to_s
    assert_equal chemical_stock[:name], @stock.name
    assert_equal chemical_stock[:stored], @stock.stored
  end

  test "農薬在庫削除(実行)" do
    assert_difference('ChemicalStock.count', -1) do
      delete chemical_stock_path(chemical_id: @chemical_term.id, id: @stock.id)
    end
    assert_response :success
    
    assert_nil ChemicalStock.find_by(id: @stock.id)
  end
end
