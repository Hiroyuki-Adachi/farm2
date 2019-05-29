require 'test_helper'

class SeedlingResultsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "育苗使用(一覧)" do
    get :index
    assert_response :success
  end

  test "育苗使用(検閲者)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :success
  end

  test "育苗使用(利用者)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

  test "育苗使用(担当)" do
    get :edit, params: {seedling_home_id: seedling_homes(:seedling_home1)}
    assert_response :success
  end

  test "育苗使用(担当:更新)" do
    seedling_result_insert = {seedling_results_attributes: [{work_result_id: 5581, quantity: 100}]}
    assert_difference('SeedlingResult.count') do
      patch :update, params: {seedling_home_id: seedling_homes(:seedling_home1), seedling_home: seedling_result_insert}
    end
    assert_redirected_to edit_seedling_result_path(seedling_home_id: seedling_homes(:seedling_home1))

    seedling_result_delete = {seedling_results_attributes: [{_destroy: true, id: seedling_results(:seedling_home1_genka)}]}
    assert_no_difference('WorkResult.count') do
      assert_difference('SeedlingResult.count', -1) do
        patch :update, params: {seedling_home_id: seedling_homes(:seedling_home1), seedling_home: seedling_result_delete}
      end
    end
    assert_redirected_to edit_seedling_result_path(seedling_home_id: seedling_homes(:seedling_home1))
  end
end
