require 'test_helper'

class SeedlingResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @seedling_home = seedling_homes(:seedling_home1)
  end

  test "育苗使用(一覧)" do
    get seedling_results_path
    assert_response :success
  end

  test "育苗使用(検閲者)" do
    login_as(users(:user_checker))
    get seedling_results_path
    assert_response :success
  end

  test "育苗使用(利用者)" do
    login_as(users(:user_user))
    get seedling_results_path
    assert_response :error
  end

  test "育苗使用(担当)" do
    get edit_seedling_result_path(seedling_home_id: @seedling_home)
    assert_response :success
  end

  test "育苗使用(担当:更新)(登録)" do
    work_result = work_results(:work_results300)
    seedling_result_insert = {seedling_results_attributes: [{work_result_id: work_result.id, quantity: 100}]}
    assert_difference('SeedlingResult.count') do
      patch seedling_result_path(seedling_home_id: @seedling_home), params: {seedling_home: seedling_result_insert}
    end
    assert_redirected_to edit_seedling_result_path(seedling_home_id: @seedling_home)

    seedling_result = SeedlingResult.last
    assert_equal seedling_result_insert[:seedling_results_attributes][0][:work_result_id], seedling_result.work_result_id
    assert_equal seedling_result_insert[:seedling_results_attributes][0][:quantity], seedling_result.quantity
    assert_equal @seedling_home.id, seedling_result.seedling_home_id
  end

  test "育苗使用(担当:更新)(削除)" do
    seedling_home1_genka = seedling_results(:seedling_home1_genka)
    seedling_result_delete = {seedling_results_attributes: [{_destroy: true, id: seedling_home1_genka.id}]}
    assert_no_difference('WorkResult.count') do
      assert_difference('SeedlingResult.count', -1) do
        patch seedling_result_path(seedling_home_id: @seedling_home), params: {seedling_home: seedling_result_delete}
      end
    end
    assert_redirected_to edit_seedling_result_path(seedling_home_id: @seedling_home)

    assert_nil SeedlingResult.find_by(id: seedling_home1_genka.id)
  end
end
