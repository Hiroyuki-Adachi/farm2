require 'test_helper'

class Plans::WorkTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
  end

  test "育苗計画(品種)(表示)" do
    get :new
    assert_response :success
  end

  test "育苗計画(品種)(表示)(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :new
    assert_response :error
  end

  test "育苗計画(品種)(作成)" do
    work_type = work_types(:work_type_koshi)
    PlanWorkType.destroy_all
    assert_difference('PlanWorkType.count') do
      post :create, params: {work_types: {work_type.id => {month: 4, area: 100}}}
    end
    assert_redirected_to new_plans_seedling_path
  end
end
