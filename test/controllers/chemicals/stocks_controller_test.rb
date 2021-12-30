require "test_helper"

class Chemicals::StocksControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @chemical_term = chemical_terms(:chemical_term_3_2015)
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
end
