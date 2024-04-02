require 'test_helper'

class DryingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "乾燥一覧" do
    get :index
    assert_response :success
  end

  test "乾燥一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "乾燥作成" do
    assert_difference('Drying.count') do
      post :create, params: {drying: {
        term: systems(:s2015).term, 
        carried_on: works(:work_harvest1).worked_at, 
        home_id: homes(:home5).id
      }}
    end
    assert_redirected_to dryings_path
  end

  test "乾燥照会" do
    get :show, params: {id: homes(:home31).id}
    assert_response :success
  end

  test "乾燥編集" do
    get :edit, params: {id: dryings(:drying1).id}
    assert_response :success
  end

  test "乾燥登録(カントリー)" do
    assert_difference('Adjustment.count', -1) do
      assert_difference('DryingMoth.count', 4) do
        assert_no_difference('Drying.count') do
          post :update, params: {id: dryings(:drying2).id, drying: {
            term: systems(:s2015).term, 
            shipped_on: dryings(:drying2).carried_on + 1,
            drying_type_id: 1,
            drying_moths_attributes: [
              {moth_count: 1, moth_no: 1000, water_content: 14.1, moth_weight: 760, rice_weight: 529.2},
              {moth_count: 2, moth_no: 1001, water_content: 14.9, moth_weight: 688, rice_weight: 487.7},
              {moth_count: 3},
              {moth_count: 4}
            ]
          }}
        end
      end
    end
    assert_redirected_to drying_path(dryings(:drying2).home_id)
  end

  test "乾燥登録(乾燥調整)" do
    assert_difference('Adjustment.count', 1) do
      assert_difference('DryingMoth.count', -4) do
        assert_no_difference('Drying.count') do
          post :update, params: {id: dryings(:drying1).id, drying: {
            term: systems(:s2015).term, 
            shipped_on: dryings(:drying1).carried_on + 1,
            drying_type_id: 2,
            adjustment_attributes: {
              home_id: dryings(:drying1).home_id, rice_bag: 65, half_weight: 25, waste_weight: 120
            }
          }}
        end
      end
    end
    assert_redirected_to drying_path(dryings(:drying1).home_id)
  end

  test "乾燥登録(乾燥のみ)" do
    assert_difference('Adjustment.count', 1) do
      assert_difference('DryingMoth.count', -4) do
        assert_no_difference('Drying.count') do
          post :update, params: {id: dryings(:drying1).id, drying: {
            term: systems(:s2015).term, 
            shipped_on: dryings(:drying1).carried_on + 1,
            drying_type_id: 3,
            adjustment_attributes: {
              home_id: homes(:home31).id, rice_bag: 65, half_weight: 25, waste_weight: 120
            }
          }}
        end
      end
    end
    assert_redirected_to drying_path(dryings(:drying1).home_id)
  end

  test "乾燥削除" do
    assert_difference('Adjustment.count', -1) do
      assert_difference('Drying.count', -1) do
        delete :destroy, params: {id: dryings(:drying2).id}
      end
    end
    assert_redirected_to dryings_path

    assert_difference('DryingMoth.count', -4) do
      assert_difference('Drying.count', -1) do
        delete :destroy, params: {id: dryings(:drying1).id}
      end
    end
    assert_redirected_to dryings_path
  end

  test "乾燥複写" do
    assert_difference('Drying.count') do
      post :copy, params: {id: dryings(:drying1).id}
    end
  end
end
