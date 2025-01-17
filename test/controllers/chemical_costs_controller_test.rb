require 'test_helper'

class ChemicalCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @chemical_term_id = chemical_terms(:chemical_term_3_2015).id
    @chemical_work_type_genka3 = chemical_work_types(:chemical_work_type_genka3)
  end

  test "薬剤原価" do
    get chemical_costs_path
    assert_response :success
  end

  test "薬剤原価(管理者以外)" do
    login_as(users(:user_checker))
    get chemical_costs_path
    assert_response :error
  end

  test "薬剤原価新規作成(表示)" do
    get new_chemical_cost_path, params: {chemical_term_id: @chemical_term_id, work_type_id: 1}, as: :turbo_stream
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  test "薬剤原価新規作成(実行)" do
    chemical_work_type = {chemical_term_id: @chemical_term_id, work_type_id: 1, quantity: 1}
    assert_difference('ChemicalWorkType.count') do
      post chemical_costs_path, params: {
        chemical_work_type: chemical_work_type,
        regist: true
      }, as: :turbo_stream
    end

    new_chemical_work_type = ChemicalWorkType.last
    assert_equal @chemical_term_id, new_chemical_work_type.chemical_term_id
    assert_equal chemical_work_type[:work_type_id], new_chemical_work_type.work_type_id
    assert_equal chemical_work_type[:quantity], new_chemical_work_type.quantity
  end

  test "薬剤原価新規作成(戻る)" do
    chemical_work_type = {chemical_term_id: @chemical_term_id, work_type_id: 2, quantity: 1}
    assert_no_difference('ChemicalWorkType.count') do
      post chemical_costs_path, params: {
        chemical_work_type: chemical_work_type,
        back: true
      }, as: :turbo_stream
    end
  end

  test "薬剤原価新規作成(実行)(値がゼロ)" do
    chemical_work_type = {chemical_term_id: @chemical_term_id, work_type_id: 4, quantity: 0}
    assert_no_difference('ChemicalWorkType.count') do
      post chemical_costs_path, params: {
        chemical_work_type: chemical_work_type,
        regist: true
      }, as: :turbo_stream
    end
  end

  test "薬剤原価更新(表示)" do
    get edit_chemical_cost_path(@chemical_work_type_genka3.id), as: :turbo_stream
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  test "薬剤原価更新(実行)" do
    chemical_work_type = {
      chemical_term_id: @chemical_work_type_genka3.chemical_term_id,
      work_type_id: @chemical_work_type_genka3.work_type_id,
      quantity: 2
    }

    assert_no_difference('ChemicalWorkType.count') do
      patch chemical_cost_path(@chemical_work_type_genka3.id), params: {
        chemical_work_type: chemical_work_type,
        regist: true
      }, as: :turbo_stream
    end
    assert_response :success

    @chemical_work_type_genka3.reload
    assert_equal chemical_work_type[:quantity], @chemical_work_type_genka3.quantity
  end

  test "薬剤原価更新(戻る)" do
    chemical_work_type = {
      chemical_term_id: @chemical_work_type_genka3.chemical_term_id,
      work_type_id: @chemical_work_type_genka3.work_type_id,
      quantity: 5
    }
    original_quantity = @chemical_work_type_genka3.quantity

    assert_no_difference('ChemicalWorkType.count') do
      patch chemical_cost_path(@chemical_work_type_genka3.id), params: {
        chemical_work_type: chemical_work_type,
        back: true
      }, as: :turbo_stream
    end
    assert_response :success

    @chemical_work_type_genka3.reload
    assert_equal original_quantity, @chemical_work_type_genka3.quantity
  end

  test "薬剤原価更新(削除)" do
    chemical_work_type = {
      chemical_term_id: @chemical_work_type_genka3.chemical_term_id,
      work_type_id: @chemical_work_type_genka3.work_type_id,
      quantity: 0
    }
    assert_difference('ChemicalWorkType.count', -1) do
      patch chemical_cost_path(@chemical_work_type_genka3.id), params: {
        chemical_work_type: chemical_work_type,
        regist: true
      }, as: :turbo_stream
    end
    assert_response :success

    assert_nil ChemicalWorkType.find_by(id: @chemical_work_type_genka3.id)
  end
end
