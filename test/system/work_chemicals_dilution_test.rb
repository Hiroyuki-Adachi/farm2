require "application_system_test_case"

class WorkChemicalsDilutionTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    @work = works(:works1)

    visit root_path
    fill_in 'login_name', with: @user.login_name
    fill_in 'password', with: 'password'
    click_button '認証する'
    assert_selector 'a', exact_text: '作業日報管理'
  end

  test "希釈相互変換(使用量単位がccの場合)" do
    chemical = chemicals(:chemicals2)
    chemical.update!(aqueous_flag: true, unit: "cc")

    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'

    quantity_field = find("input[name='chemicals[#{chemical.id}][1][quantity]']", visible: :all)
    dilution_amount_field = find("input[name='chemicals[#{chemical.id}][1][dilution_amount]']", visible: :all)
    magnification_field = find("input[name='chemicals[#{chemical.id}][1][magnification]']", visible: :all)

    choose "chemicals_#{chemical.id}_1_#{Dilution::L.id}", visible: :all
    quantity_field.set("100")
    quantity_field.send_keys(:tab)
    dilution_amount_field.set("100")
    dilution_amount_field.send_keys(:tab)
    assert_equal "1000.0", magnification_field.value

    choose "chemicals_#{chemical.id}_1_#{Dilution::MAG.id}", visible: :all
    magnification_field = find("input[name='chemicals[#{chemical.id}][1][magnification]']", visible: :all)
    dilution_amount_field = find("input[name='chemicals[#{chemical.id}][1][dilution_amount]']", visible: :all)
    magnification_field.set("200")
    magnification_field.send_keys(:tab)
    assert_equal "20.0", dilution_amount_field.value
  end

  test "希釈相互変換(使用量単位が本など個数単位の場合はbase_quantityで実量換算される)" do
    chemical = chemicals(:chemicals2)
    chemical.update!(aqueous_flag: true, unit: "本", base_quantity: 500)

    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'

    quantity_field = find("input[name='chemicals[#{chemical.id}][1][quantity]']", visible: :all)
    dilution_amount_field = find("input[name='chemicals[#{chemical.id}][1][dilution_amount]']", visible: :all)
    magnification_field = find("input[name='chemicals[#{chemical.id}][1][magnification]']", visible: :all)

    choose "chemicals_#{chemical.id}_1_#{Dilution::MAG.id}", visible: :all
    quantity_field.set("2")
    quantity_field.send_keys(:tab)
    magnification_field.set("200")
    magnification_field.send_keys(:tab)

    # 2本 x 500ml(base_quantity) = 1000ml を基準に換算されるため 200倍 => 200ℓ
    assert_equal "200.0", dilution_amount_field.value
  end

  test "希釈相互変換(個数単位でbase_quantity未設定の場合は例外にならず倍率欄が空になる)" do
    chemical = chemicals(:chemicals2)
    chemical.update!(aqueous_flag: true, unit: "本", base_quantity: 0)

    visit new_work_use_chemical_path(work_id: @work)
    assert_selector 'h1', text: '作業日報(薬剤)登録'

    quantity_field = find("input[name='chemicals[#{chemical.id}][1][quantity]']", visible: :all)
    dilution_amount_field = find("input[name='chemicals[#{chemical.id}][1][dilution_amount]']", visible: :all)
    magnification_field = find("input[name='chemicals[#{chemical.id}][1][magnification]']", visible: :all)

    choose "chemicals_#{chemical.id}_1_#{Dilution::L.id}", visible: :all
    quantity_field.set("2")
    quantity_field.send_keys(:tab)
    dilution_amount_field.set("100")
    dilution_amount_field.send_keys(:tab)

    assert_equal "", magnification_field.value
    assert_selector 'h1', text: '作業日報(薬剤)登録'
  end
end
