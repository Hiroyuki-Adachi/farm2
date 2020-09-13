require 'test_helper'

class Plans::SeedlingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
  end

  test "育苗計画(世帯)(表示)" do
    get :new
    assert_response :success
  end

  test "育苗計画(世帯)(表示)(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :new
    assert_response :error
  end

  test "育苗計画(品種)(作成)" do
    plan_work_type = plan_work_types(:plan_work_type_kinu)
    assert_difference('PlanSeedling.count') do
      post :create, params: {seedlings: {1 => {plan_work_type.id => {quantity: 100}}}}
    end
    assert_redirected_to plans_seedlings_path
  end  

  test "育苗計画(品種)(一覧)" do
    get :index
    assert_response :success
  end  
end
