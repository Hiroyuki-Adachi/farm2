require 'test_helper'

class ChemicalCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "薬剤原価" do
    get :index
    assert_response :success
  end

  test "薬剤原価(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "薬剤原価新規作成(実行)" do
    chemical_term_id = chemical_terms(:chemical_term_3_2015).id
    work_type_id = work_types(:work_type_koshi).id
    chemical_price = 5500
    quantity = 12.3
    assert_no_difference('ChemicalTerm.count') do
      assert_difference('ChemicalWorkType.where.not(quantity: 0).count') do
        post :create, {
          chemical_terms: [{id: chemical_term_id, price: chemical_price}],
          chemical_work_types: [{
            work_type_id: work_type_id,
            chemical_term_id: chemical_term_id,
            quantity: quantity
          }]
        }
      end
    end
    assert_redirected_to chemical_costs_path

    assert_equal chemical_price, ChemicalTerm.find(chemical_term_id).price
    chemical_work_type = ChemicalWorkType.find_by(work_type_id: work_type_id, chemical_term_id: chemical_term_id)
    assert_equal quantity, chemical_work_type.quantity
  end
end
