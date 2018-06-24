require 'test_helper'

class ExpensesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @expense = expenses(:expense_upd)
    @update = {term: 2015, payed_on: "2015-01-01", content: "テスト", amount: 98_765,
      expense_work_types_attributes: [{work_type_id: work_types(:work_type_koshi), rate: 2.0}]
    }
  end

  test "経費原価" do
    get :index
    assert_response :success
  end

  test "経費原価(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "経費原価新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "経費原価新規作成(実行)" do
    assert_difference('ExpenseWorkType.where(rate: 2.0).count') do
      assert_difference('Expense.count') do
        post :create, expense: @update
      end
    end

    assert_redirected_to expenses_path
  end

  test "経費原価変更(表示)" do
    get :edit, id: @expense
    assert_response :success
  end

  test "経費原価変更(実行)" do
    assert_difference('ExpenseWorkType.count') do
      assert_no_difference('Expense.count') do
        patch :update, id: @expense, expense: @update
      end
    end
    assert_redirected_to expenses_path
  end

  test "経費原価削除" do
    assert_difference('Expense.count', -1) do
      delete :destroy, id: @expense
    end
    assert_redirected_to expenses_path
  end
end
