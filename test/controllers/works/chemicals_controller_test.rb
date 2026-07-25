require "test_helper"

class Works::ChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @work = works(:work_not_fixed)
  end

  test "作業変更(薬品)(表示)" do
    get new_work_use_chemical_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(薬品)(表示)(作付明細なしの農地は除外)" do
    land_without_cost = lands(:land_land_cost2)
    work_land = @work.work_lands.create!(
      land: land_without_cost,
      work_type: work_types(:work_type_koshi),
      display_order: 99
    )

    get new_work_use_chemical_path(work_id: @work)

    assert_response :success
    assert_select "#work_land_#{work_land.id}", false
    assert_no_match land_without_cost.place, response.body
  end

  test "作業変更(薬品)(表示)(確定済)" do
    get new_work_use_chemical_path(work_id: works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(薬品)(表示)(希釈無のとき希釈情報は無選択かつdisabled)" do
    work = works(:works1)
    chemical = chemicals(:chemicals2)
    work_chemical = work.work_chemicals.find_by(chemical_id: chemical.id, chemical_group_no: 1)
    assert_not chemical.aqueous_flag
    assert_equal Dilution::NONE.id, work_chemical.dilution_id

    get new_work_use_chemical_path(work_id: work)

    assert_response :success
    assert_select "#chemicals_#{chemical.id}_1_#{Dilution::NONE.id}[checked]"
    assert_select "input[name='chemicals[#{chemical.id}][1][magnification]'][disabled]"
    assert_select "input[name='chemicals[#{chemical.id}][1][dilution_amount]'][disabled]"
  end

  test "作業変更(薬品)(変更)" do
    chemical = chemicals(:chemicals3)
    chemicals = { chemical.id => { 1 => {
      dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
    } } }
    assert_difference('WorkChemical.count') do
      post work_use_chemicals_path(work_id: @work), params: {
        chemicals: chemicals,
        work: { chemical_group_flag: false }
      }
    end
    assert_redirected_to work_path(id: @work)

    created_work_chemical = WorkChemical.last
    assert_equal @work.id, created_work_chemical.work_id
    assert_equal chemical.id, created_work_chemical.chemical_id
    assert_equal chemicals[4][1][:dilution_id], created_work_chemical.dilution_id
    assert_equal chemicals[4][1][:magnification], created_work_chemical.magnification
  end

  test "作業変更(薬品)(変更)(希釈なしに変更すると希釈倍率がクリアされる)" do
    chemical = chemicals(:chemicals3)

    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: { chemical.id => { 1 => {
        dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
      } } },
      work: { chemical_group_flag: false }
    }
    work_chemical = WorkChemical.find_by(work_id: @work.id, chemical_id: chemical.id, chemical_group_no: 1)
    assert_equal 10, work_chemical.magnification.to_i

    # ブラウザ上は dilution_id を無に切り替えると magnification 欄が disabled になり送信されないため、
    # そのケースを再現するためにパラメータから magnification を含めない
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: { chemical.id => { 1 => {
        dilution_id: 0, quantity: 10
      } } },
      work: { chemical_group_flag: false }
    }
    work_chemical.reload
    assert_equal 0, work_chemical.dilution_id
    assert_nil work_chemical.magnification
    assert_nil work_chemical.dilution_amount
  end

  test "作業変更(薬品)(変更)(薬剤グループ)" do
    work_lands_not_fixed1 = work_lands(:work_lands_not_fixed1)
    chemical = chemicals(:chemicals3)
    chemicals = { chemical.id => { 1 => {
      dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
    } } }
    chemical_group_no = 1

    # 薬剤グループの指定で値に反映される
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: chemicals,
      work: { chemical_group_flag: true },
      work_lands: { work_lands_not_fixed1.id => chemical_group_no }
    }
    work_lands_not_fixed1.reload
    assert_equal chemical_group_no, work_lands_not_fixed1.chemical_group_no

    # 薬剤グループ解除でゼロが設定される
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: chemicals,
      work: { chemical_group_flag: false }
    }
    work_lands_not_fixed1.reload
    assert_equal 0, work_lands_not_fixed1.chemical_group_no
  end
end
