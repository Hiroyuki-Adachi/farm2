require "application_system_test_case"

# #1352 薬剤グループごとに選んだ作業地が、その作業の作業地として保存される
class WorkChemicalGroupsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @work = works(:work_not_fixed)
    @land1 = work_lands(:work_lands_not_fixed1)
    @land2 = work_lands(:work_lands_not_fixed2)
    # グループ別面積の欄は薬剤の行に描画されるため、薬剤を1件登録しておく
    @work.work_chemicals.create!(chemical: chemicals(:chemicals3), chemical_group_no: 1, quantity: 10,
                                 dilution_id: Dilution::NONE.id)

    visit root_path
    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'
  end

  test "グループごとに選んだ作業地の薬剤グループ番号が保存される" do
    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'

    check 'work_chemical_group_flag'
    check "work_land_#{@land1.id}"
    choose 'col_group_1'
    check "work_land_#{@land2.id}"
    click_button '登録'

    assert_current_path work_path(@work)
    assert_equal 1, @land1.reload.chemical_group_no
    assert_equal 2, @land2.reload.chemical_group_no
  end

  test "作業地の選択を外すと薬剤グループ番号は0で保存される" do
    @land1.update!(chemical_group_no: 1)
    @work.update!(chemical_group_flag: true)

    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'

    uncheck "work_land_#{@land1.id}"
    click_button '登録'

    assert_current_path work_path(@work)
    assert_equal 0, @land1.reload.chemical_group_no
  end
end
