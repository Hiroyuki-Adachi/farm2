require 'test_helper'

class SeedlingCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @update_chemical = {price: 1000}
    @chemical_id = chemical_terms(:chemical_term_3_2015).chemical_id
    @update_system = {seedling_chemical_id: @chemical_id, seedling_price: 2000}
    @work_type_id = work_types(:work_type_koshi).id
    @update_seedlings = [{seedling_quantity: 10, soil_quantity: 20, seed_cost: 30, work_type_id: @work_type_id, term: 2015}]
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
        post :create, {chemical: @update_chemical, system: @update_system, seedlings: @update_seedlings}
      end
    end
    assert_redirected_to seedling_costs_path

    assert_equal @update_chemical[:price], ChemicalTerm.find(chemical_terms(:chemical_term_3_2015).id).price
    assert_equal @chemical_id, System.find(systems(:s2015).id).seedling_chemical_id
    assert_equal @update_system[:seedling_price], System.find(systems(:s2015).id).seedling_price
    assert_equal @update_seedlings[0][:seedling_quantity], Seedling.find_by(term: 2015, work_type_id: @work_type_id).seedling_quantity
  end
end
