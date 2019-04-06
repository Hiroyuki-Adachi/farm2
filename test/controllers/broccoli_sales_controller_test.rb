require 'test_helper'

class BroccoliSalesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work = works(:work_broccoli)
  end

  test "ブロッコリ売上一覧" do
    get :index
    assert_response :success
  end

  test "ブロッコリ売上一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

#  test "ブロッコリ売上登録" do
#    assert_difference('WorkBroccoli.count') do
#      post :create, params: {work_broccoli: [work_id: @work.id, shipped_on: @work.worked_at, sale: 15_000, cost: 3200]}
#    end
#    assert_redirected_to broccoli_sales_path
#  end
end
