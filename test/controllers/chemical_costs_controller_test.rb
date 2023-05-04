require 'test_helper'

class ChemicalCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @chemical_term_id = chemical_terms(:chemical_term_3_2015).id
    @chemical_work_type_genka3 = chemical_work_types(:chemical_work_type_genka3)
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

  test "薬剤原価新規作成(表示)" do
    get :new, params: {chemical_term_id: @chemical_term_id, work_type_id: 1}, as: :turbo_stream
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  test "薬剤原価新規作成(実行)" do
    assert_difference('ChemicalWorkType.count') do
      post :create, params: {
        chemical_work_type: {chemical_term_id: @chemical_term_id, work_type_id: 1, quantity: 1},
        regist: true
      }, as: :turbo_stream
    end

    assert_no_difference('ChemicalWorkType.count') do
      post :create, params: {
        chemical_work_type: {chemical_term_id: @chemical_term_id, work_type_id: 2, quantity: 1},
        back: true
      }, as: :turbo_stream
    end

    assert_no_difference('ChemicalWorkType.count') do
      post :create, params: {
        chemical_work_type: {chemical_term_id: @chemical_term_id, work_type_id: 4, quantity: 0},
        regist: true
      }, as: :turbo_stream
    end
  end

  test "薬剤原価更新(表示)" do
    get :edit, params: {id: @chemical_work_type_genka3.id}, as: :turbo_stream
    assert_response :success
    assert_equal "text/vnd.turbo-stream.html; charset=utf-8", response.content_type
  end

  test "薬剤原価更新(実行)" do
    assert_no_difference('ChemicalWorkType.count') do
      patch :update, params: {
        id: @chemical_work_type_genka3.id, 
        chemical_work_type: {
          chemical_term_id: @chemical_work_type_genka3.chemical_term_id,
          work_type_id: @chemical_work_type_genka3.work_type_id,
          quantity: 2
        },
        regist: true
      }, as: :turbo_stream
    end
    assert_equal 2, ChemicalWorkType.find(@chemical_work_type_genka3.id).quantity
    assert_response :success

    assert_no_difference('ChemicalWorkType.count') do
      patch :update, params: {
        id: @chemical_work_type_genka3.id, 
        chemical_work_type: {
          chemical_term_id: @chemical_work_type_genka3.chemical_term_id,
          work_type_id: @chemical_work_type_genka3.work_type_id,
          quantity: 3
        },
        back: true
      }, as: :turbo_stream
    end
    assert_not_equal 3, ChemicalWorkType.find(@chemical_work_type_genka3.id).quantity
    assert_response :success

    assert_difference('ChemicalWorkType.count', -1) do
      patch :update, params: {
        id: @chemical_work_type_genka3.id, 
        chemical_work_type: {
          chemical_term_id: @chemical_work_type_genka3.chemical_term_id,
          work_type_id: @chemical_work_type_genka3.work_type_id,
          quantity: 0
        },
        regist: true
      }, as: :turbo_stream
    end
    assert_response :success
  end
end
