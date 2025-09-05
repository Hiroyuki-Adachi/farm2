require 'test_helper'

class DryingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "乾燥一覧" do
    get dryings_path
    assert_response :success
  end

  test "乾燥一覧(管理者以外)" do
    login_as(users(:user_checker))
    get dryings_path
    assert_response :error
  end

  test "乾燥作成" do
    new_drying = {
      term: systems(:s2015).term, 
      carried_on: works(:work_harvest1).worked_at, 
      home_id: homes(:home5).id
    }
    assert_difference('Drying.count') do
      post dryings_path, params: {drying: new_drying}
    end
    assert_redirected_to dryings_path

    drying = Drying.last
    assert_equal new_drying[:term], drying.term
    assert_equal new_drying[:carried_on], drying.carried_on
    assert_equal new_drying[:home_id], drying.home_id
  end

  test "乾燥照会" do
    get drying_path(id: homes(:home31).id)
    assert_response :success
  end

  test "乾燥編集" do
    get edit_drying_path(id: dryings(:drying1).id)
    assert_response :success
  end

  test "乾燥登録(カントリー)" do
    drying = dryings(:drying2)
    new_drying = {
      term: systems(:s2015).term, 
      shipped_on: drying.carried_on + 1,
      drying_type_id: :country,
      drying_moths_attributes: [
        {moth_count: 1, moth_no: 1000, water_content: 14.1, moth_weight: 760, rice_weight: 529.2},
        {moth_count: 2, moth_no: 1001, water_content: 14.9, moth_weight: 688, rice_weight: 487.7},
        {moth_count: 3},
        {moth_count: 4}
      ]
    }

    assert_difference('Adjustment.count', -1) do
      assert_difference('DryingMoth.count', 4) do
        assert_no_difference('Drying.count') do
          patch drying_path(drying.id), params: {drying: new_drying}
        end
      end
    end
    assert_redirected_to drying_path(drying.home_id)

    drying.reload
    assert_equal new_drying[:term], drying.term
    assert_equal new_drying[:shipped_on], drying.shipped_on
    assert_equal new_drying[:drying_type_id], drying.drying_type_id.to_sym

    DryingMoth.where(drying_id: drying.id).order(:moth_count).each_with_index do |dm, i|
      assert_equal new_drying[:drying_moths_attributes][i][:moth_count], dm.moth_count
      if new_drying[:drying_moths_attributes][i][:moth_no]
        assert_equal new_drying[:drying_moths_attributes][i][:moth_no], dm.moth_no
      else
        assert_nil dm.moth_no
      end
      if new_drying[:drying_moths_attributes][i][:water_content]
        assert_equal new_drying[:drying_moths_attributes][i][:water_content], dm.water_content
      else
        assert_nil dm.water_content
      end
      if new_drying[:drying_moths_attributes][i][:moth_weight]
        assert_equal new_drying[:drying_moths_attributes][i][:moth_weight], dm.moth_weight
      else
        assert_nil dm.moth_weight
      end
      if new_drying[:drying_moths_attributes][i][:rice_weight]
        assert_equal new_drying[:drying_moths_attributes][i][:rice_weight], dm.rice_weight
      else
        assert_nil dm.rice_weight
      end
    end

    assert_nil Adjustment.find_by(drying_id: drying.id)
  end

  test "乾燥登録(乾燥調整)" do
    drying = dryings(:drying1)
    new_drying = {
      term: systems(:s2015).term, 
      shipped_on: drying.carried_on + 1,
      drying_type_id: :self,
      adjustment_attributes: {
        home_id: drying.home_id, rice_bag: 65, half_weight: 25, waste_weight: 120
      }
    }
    assert_difference('Adjustment.count', 1) do
      assert_difference('DryingMoth.count', -4) do
        assert_no_difference('Drying.count') do
          patch drying_path(drying.id), params: {drying: new_drying}
        end
      end
    end
    assert_redirected_to drying_path(drying.home_id)

    drying.reload
    assert_equal new_drying[:term], drying.term
    assert_equal new_drying[:shipped_on], drying.shipped_on
    assert_equal new_drying[:drying_type_id], drying.drying_type_id.to_sym

    assert_empty DryingMoth.where(drying_id: drying.id)

    adjustment = Adjustment.find_by(drying_id: drying.id)
    assert_not_nil adjustment
    assert_equal new_drying[:adjustment_attributes][:home_id], adjustment.home_id
    assert_equal new_drying[:adjustment_attributes][:rice_bag], adjustment.rice_bag
    assert_equal new_drying[:adjustment_attributes][:half_weight], adjustment.half_weight
    assert_equal new_drying[:adjustment_attributes][:waste_weight], adjustment.waste_weight
  end

  test "乾燥登録(乾燥のみ)" do
    drying = dryings(:drying1)
    new_drying = {
      term: systems(:s2015).term, 
      shipped_on: drying.carried_on + 1,
      drying_type_id: :another,
      adjustment_attributes: {
        home_id: homes(:home31).id, rice_bag: 65, half_weight: 25, waste_weight: 120
      }
    }
    assert_difference('Adjustment.count', 1) do
      assert_difference('DryingMoth.count', -4) do
        assert_no_difference('Drying.count') do
          patch drying_path(drying.id), params: {drying: new_drying}
        end
      end
    end
    assert_redirected_to drying_path(drying.home_id)

    drying.reload
    assert_equal new_drying[:term], drying.term
    assert_equal new_drying[:shipped_on], drying.shipped_on
    assert_equal new_drying[:drying_type_id], drying.drying_type_id.to_sym

    assert_empty DryingMoth.where(drying_id: drying.id)

    adjustment = Adjustment.find_by(drying_id: drying.id)
    assert_not_nil adjustment
    assert_equal new_drying[:adjustment_attributes][:home_id], adjustment.home_id
    assert_equal new_drying[:adjustment_attributes][:rice_bag], adjustment.rice_bag
    assert_equal new_drying[:adjustment_attributes][:half_weight], adjustment.half_weight
    assert_equal new_drying[:adjustment_attributes][:waste_weight], adjustment.waste_weight
  end

  test "乾燥削除(乾燥調整)" do
    drying = dryings(:drying2)
    assert_difference('Adjustment.count', -1) do
      assert_difference('Drying.count', -1) do
        delete drying_path(drying.id)
      end
    end
    assert_redirected_to dryings_path

    assert_nil Drying.find_by(id: drying.id)
    assert_empty Adjustment.where(drying_id: drying.id)
  end

  test "乾燥削除(カントリー)" do
    drying = dryings(:drying1)
    assert_difference('DryingMoth.count', -4) do
      assert_difference('Drying.count', -1) do
        delete drying_path(drying.id)
      end
    end
    assert_redirected_to dryings_path

    assert_nil Drying.find_by(id: drying.id)
    assert_empty DryingMoth.where(drying_id: drying.id)
  end

  test "乾燥複写" do
    drying = dryings(:drying1)
    assert_difference('Drying.count') do
      post copy_drying_path(drying.id)
    end

    copy_drying = Drying.last
    assert_equal drying.term, copy_drying.term
    assert_equal drying.carried_on, copy_drying.carried_on
    assert_equal drying.home_id, copy_drying.home_id
  end
end
