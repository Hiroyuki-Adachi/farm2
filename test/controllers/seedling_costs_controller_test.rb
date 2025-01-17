require 'test_helper'

class SeedlingCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @update_chemical = {price: 1000}
    @chemical_id = chemical_terms(:chemical_term_3_2015).chemical_id
    @update_system = {seedling_chemical_id: @chemical_id, seedling_price: 2000}
    @work_type_id = work_types(:work_type_koshi).id
    @update_seedlings = [{soil_quantity: 20, seed_cost: 30, work_type_id: @work_type_id, term: 2015}]
    @seedling = seedlings(:seedling1)
  end

  test "育苗原価" do
    get seedling_costs_path
    assert_response :success
  end

  test "育苗原価(管理者以外)" do
    login_as(users(:user_checker))
    get seedling_costs_path
    assert_response :error
  end

  test "育苗原価登録(実行)" do
    assert_no_difference('System.count') do
      assert_no_difference('ChemicalTerm.count') do
        post seedling_costs_path, params: {chemical: @update_chemical, system: @update_system, seedlings: @update_seedlings}
      end
    end
    assert_redirected_to seedling_costs_path

    assert_equal @chemical_id, System.find(systems(:s2015).id).seedling_chemical_id
    assert_equal @update_system[:seedling_price], System.find(systems(:s2015).id).seedling_price
  end

  test "育苗担当" do
    get edit_seedling_cost_path(seedling_id: @seedling.id)
    assert_response :success
  end

  test "育苗担当(実行)(挿入)" do
    sowed_on = Time.zone.local(2015, 5, 1)
    seedling_insert = {seedling_homes_attributes: [{home_id: 3, quantity: 200, sowed_on: sowed_on}]}
    assert_difference('SeedlingHome.count') do
      patch seedling_cost_path(seedling_id: @seedling.id), params: {seedling: seedling_insert}
    end
    assert_redirected_to edit_seedling_cost_path(seedling_id: seedlings(:seedling1).id)

    seedling_home = SeedlingHome.last
    assert_equal seedling_insert[:seedling_homes_attributes][0][:home_id], seedling_home.home_id
    assert_equal seedling_insert[:seedling_homes_attributes][0][:quantity], seedling_home.quantity
    assert_equal sowed_on, seedling_home.sowed_on.in_time_zone
    assert_equal @seedling.id, seedling_home.seedling_id
  end

  test "育苗担当(実行)(削除)" do
    seedling_home = seedling_homes(:seedling_home1)
    seedling_delete = {seedling_homes_attributes: [{id: seedling_home.id, _destroy: 1}]}
    assert_difference('SeedlingHome.count', -1) do
      patch seedling_cost_path(seedling_id: @seedling.id), params: {seedling: seedling_delete}
    end
    assert_redirected_to edit_seedling_cost_path(seedling_id: @seedling.id)

    assert_nil SeedlingHome.find_by(id: seedling_home.id)
  end
end
