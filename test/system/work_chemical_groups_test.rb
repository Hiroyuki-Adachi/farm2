require "application_system_test_case"

# #1352 薬剤グループごとに選んだ作業地が、その作業の作業地として保存される
class WorkChemicalGroupsTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @work = works(:work_not_fixed)
    @land1 = work_lands(:work_lands_not_fixed1)
    @land2 = work_lands(:work_lands_not_fixed2)

    visit root_path
    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'
  end

  test "グループごとに選んだ作業地の薬剤グループ番号が保存される" do
    register_chemical
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
    register_chemical
    @land1.update!(chemical_group_no: 1)
    @work.update!(chemical_group_flag: true)

    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'

    uncheck "work_land_#{@land1.id}"
    click_button '登録'

    assert_current_path work_path(@work)
    assert_equal 0, @land1.reload.chemical_group_no
  end

  # #1359 薬剤が1件も表示されない作業でも、薬剤グループと作業地の操作でJSエラーにならない
  test "薬剤が表示されない作業でも薬剤グループで作業地を選んで保存できる" do
    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'
    assert_no_selector "input[name^='chemicals[']"

    check 'work_chemical_group_flag'
    check "work_land_#{@land1.id}"
    assert_selector '#group_areas_span', exact_text: format('%.1f', @land1.land.area)
    choose 'col_group_1'
    check "work_land_#{@land2.id}"
    assert_selector '#group_areas_span', exact_text: format('%.1f', @land2.land.area)
    click_button '登録'

    assert_current_path work_path(@work)
    assert_equal 1, @land1.reload.chemical_group_no
    assert_equal 2, @land2.reload.chemical_group_no
  end

  # #1359 グループ別面積の欄は薬剤の件数に関係なく、グループごとに1つだけ描画される
  test "薬剤が複数あってもグループ別面積の欄は重複しない" do
    register_chemical
    @work.work_chemicals.create!(chemical: chemicals(:chemicals1), chemical_group_no: 1, quantity: 5,
                                 dilution_id: Dilution::NONE.id)

    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'
    assert_operator all("input[name^='chemicals['][name$='[quantity]']", visible: :all).size, :>=, 2

    assert_selector "input[name='group_areas[1]']", visible: :hidden, count: 1
    assert_selector "input[name='group_areas[2]']", visible: :hidden, count: 1
  end

  private

  def register_chemical
    @work.work_chemicals.create!(chemical: chemicals(:chemicals3), chemical_group_no: 1, quantity: 10,
                                 dilution_id: Dilution::NONE.id)
  end
end
