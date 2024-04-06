require 'test_helper'

class SeedlingCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @update_chemical = {price: 1000}
    @chemical_id = chemical_terms(:chemical_term_3_2015).chemical_id
    @update_system = {seedling_chemical_id: @chemical_id, seedling_price: 2000}
    @work_type_id = work_types(:work_type_koshi).id
    @update_seedlings = [{soil_quantity: 20, seed_cost: 30, work_type_id: @work_type_id, term: 2015}]
  end

  test "育苗原価" do
    get :index
    assert_response :success
  end

  test "育苗原価(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "育苗原価登録(実行)" do
    assert_no_difference('System.count') do
      assert_no_difference('ChemicalTerm.count') do
        post :create, params: {chemical: @update_chemical, system: @update_system, seedlings: @update_seedlings}
      end
    end
    assert_redirected_to seedling_costs_path

    assert_equal @chemical_id, System.find(systems(:s2015).id).seedling_chemical_id
    assert_equal @update_system[:seedling_price], System.find(systems(:s2015).id).seedling_price
  end

  test "育苗担当" do
    get :edit, params: {seedling_id: seedlings(:seedling1).id}
    assert_response :success
  end

  test "育苗担当(実行)" do
    sowed_on = Time.zone.local(2015, 5, 1)
    seedling_insert = {seedling_homes_attributes: [{home_id: 3, quantity: 200, sowed_on: sowed_on}]}
    assert_difference('SeedlingHome.count') do
      patch :update, params: {seedling_id: seedlings(:seedling1).id, seedling: seedling_insert}
    end
    assert_redirected_to edit_seedling_cost_path(seedling_id: seedlings(:seedling1).id)

    seedling_delete = {seedling_homes_attributes: [{id: seedling_homes(:seedling_home1).id, _destroy: 1}]}
    assert_difference('SeedlingHome.count', -1) do
      patch :update, params: {seedling_id: seedlings(:seedling1).id, seedling: seedling_delete}
    end
    assert_redirected_to edit_seedling_cost_path(seedling_id: seedlings(:seedling1).id)
  end
end
