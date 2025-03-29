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

  test "作業変更(薬品)(表示)(確定済)" do
    get new_work_use_chemical_path(work_id: works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(薬品)(変更)" do
    chemical = chemicals(:chemicals3)
    chemicals = { chemical.id => { 1 => {
      dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
    }}}
    assert_difference('WorkChemical.count') do
      post work_use_chemicals_path(work_id: @work), params: {
        chemicals: chemicals,
        work: {chemical_group_flag: false}
      }
    end
    assert_redirected_to work_path(id: @work)

    created_work_chemical = WorkChemical.last
    assert_equal @work.id, created_work_chemical.work_id
    assert_equal chemical.id, created_work_chemical.chemical_id
    assert_equal chemicals[4][1][:dilution_id], created_work_chemical.dilution_id
    assert_equal chemicals[4][1][:magnification], created_work_chemical.magnification
  end

  test "作業変更(薬品)(変更)(薬剤グループ)" do
    work_lands_not_fixed1 = work_lands(:work_lands_not_fixed1)
    chemical = chemicals(:chemicals3)
    chemicals = { chemical.id => { 1 => {
      dilution_id: 1, magnification: 10, dilution_amount: 10, quantity: 10
    }}}
    chemical_group_no = 1

    # 薬剤グループの指定で値に反映される
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: chemicals,
      work: {chemical_group_flag: true},
      work_lands: { work_lands_not_fixed1.id => chemical_group_no}
    }
    work_lands_not_fixed1.reload
    assert_equal chemical_group_no, work_lands_not_fixed1.chemical_group_no

    # 薬剤グループ解除でゼロが設定される
    post work_use_chemicals_path(work_id: @work), params: {
      chemicals: chemicals,
      work: {chemical_group_flag: false}
    }
    work_lands_not_fixed1.reload
    assert_equal 0, work_lands_not_fixed1.chemical_group_no
  end
end
