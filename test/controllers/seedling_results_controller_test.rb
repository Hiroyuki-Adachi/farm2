require 'test_helper'

class SeedlingResultsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "育苗使用(一覧)" do
    get :index
    assert_response :success
  end

  test "育苗使用(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "育苗使用(担当)" do
    get :edit, seedling_home_id: seedling_homes(:seedling_home1)
    assert_response :success
  end

  test "育苗使用(担当:更新)" do
    seedling_result_insert = {seedling_results_attributes: [{work_result_id: 5581, quantity: 100}]}
    assert_difference('SeedlingResult.count') do
      patch :update, seedling_home_id: seedling_homes(:seedling_home1), seedling_home: seedling_result_insert
    end
    assert_redirected_to edit_seedling_result_path(seedling_home_id: seedling_homes(:seedling_home1))
  end
end
