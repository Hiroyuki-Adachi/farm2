require 'test_helper'

class ExpenseTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "経費種別マスタ一覧" do
    get :index
    assert_response :success
  end

  test "経費種別マスタ一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
