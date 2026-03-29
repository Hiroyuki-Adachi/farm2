require 'test_helper'

class ChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @chemical = chemicals(:chemicals1)
    @new_chemical_false = {name: "試験無", phonetic: 'しけんむ', display_order: 99, chemical_type_id: chemical_types(:chemical_types1).id, this_term_flag: false}
    @new_chemical_true = {name: "試験有", phonetic: 'しけんゆう', display_order: 10, chemical_type_id: chemical_types(:chemical_types1).id, this_term_flag: true}
    @term = @user.term
  end

  test "薬剤マスタ一覧(今期)" do
    system = System.find_by(term: @term, organization_id: @user.organization_id)
    travel_to system.start_date do
      get chemicals_path
      assert_response :success

      assert_select "#chemical_annual:not([disabled])", true
    end
  end

  test "薬剤マスタ一覧(前期)" do
    system = System.find_by(term: @term - 1, organization_id: @user.organization_id)
    travel_to system.start_date do
      get chemicals_path
      assert_response :success

      assert_select "#chemical_annual[disabled]", true
    end
  end

  test "薬剤マスタ新規作成(表示)" do
    get new_chemical_path
    assert_response :success
  end

  test "薬剤マスタ新規作成(実行)(当年度無)" do
    assert_difference('Chemical.count') do
      post chemicals_path, params: {chemical: @new_chemical_false}
    end
    assert_redirected_to chemicals_path

    chemical = Chemical.last
    assert_equal @new_chemical_false[:name], chemical.name
    assert_equal @new_chemical_false[:phonetic], chemical.phonetic
    assert_equal @new_chemical_false[:display_order], chemical.display_order
    assert_equal @new_chemical_false[:chemical_type_id], chemical.chemical_type_id

    assert_not ChemicalTerm.exists?(term: @term, chemical_id: chemical)
  end

  test "薬剤マスタ新規作成(実行)(当年度有)" do
    assert_difference('Chemical.count') do
      post chemicals_path, params: {chemical: @new_chemical_true}
    end
    assert_redirected_to chemicals_path

    chemical = Chemical.last
    assert_equal @new_chemical_true[:name], chemical.name
    assert_equal @new_chemical_true[:phonetic], chemical.phonetic
    assert_equal @new_chemical_true[:display_order], chemical.display_order
    assert_equal @new_chemical_true[:chemical_type_id], chemical.chemical_type_id

    assert ChemicalTerm.exists?(term: @term, chemical_id: chemical)
  end

  test "薬剤マスタ変更(表示)" do
    get edit_chemical_path(@chemical)
    assert_response :success
  end

  test "薬剤マスタ変更(実行)(当年度無)" do
    assert_no_difference('Chemical.count') do
      patch chemical_path(@chemical), params: {chemical: @new_chemical_false}
    end
    assert_redirected_to chemicals_path

    @chemical.reload
    assert_equal @new_chemical_false[:name], @chemical.name
    assert_equal @new_chemical_false[:phonetic], @chemical.phonetic
    assert_equal @new_chemical_false[:display_order], @chemical.display_order
    assert_equal @new_chemical_false[:chemical_type_id], @chemical.chemical_type_id

    assert_not ChemicalTerm.exists?(term: @term, chemical_id: @chemical.id)
  end

  test "薬剤マスタ変更(実行)(当年度有)" do
    assert_no_difference('Chemical.count') do
      patch chemical_path(@chemical), params: {chemical: @new_chemical_true}
    end
    assert_redirected_to chemicals_path

    @chemical.reload
    assert_equal @new_chemical_true[:name], @chemical.name
    assert_equal @new_chemical_true[:phonetic], @chemical.phonetic
    assert_equal @new_chemical_true[:display_order], @chemical.display_order
    assert_equal @new_chemical_true[:chemical_type_id], @chemical.chemical_type_id

    assert ChemicalTerm.exists?(term: @term, chemical_id: @chemical.id)
  end

  test "薬剤マスタ削除" do
    assert_difference('Chemical.kept.count', -1) do
      delete chemical_path(@chemical)
    end
    assert_redirected_to chemicals_path

    assert_nil Chemical.kept.find_by(id: @chemical.id)
  end

  test "統合農薬マスタ自動紐づけ" do
    pesticide_master = PesticideMaster.create!(
      registration_number: 999999,
      name: 'ﾗｳﾝﾄﾞｱｯﾌﾟ',
      pesticide_kind: '除草剤',
      registrant_name: '試験会社',
      usage: '除草剤',
      formulation_name: '液剤',
      mixture_count: 1,
      registered_on: Date.new(2026, 3, 29)
    )
    chemical = Chemical.create!(
      name: 'ラウンドアップ',
      phonetic: 'らうんどあっぷ',
      display_order: 999,
      chemical_type: chemical_types(:chemical_types0),
      base_unit_id: 1
    )

    assert_equal 'ラウンドアップ', pesticide_master.name_normalized
    assert_nil chemical.pesticide_master_id

    post link_pesticide_masters_chemicals_path

    assert_redirected_to chemicals_path
    assert_equal pesticide_master.id, chemical.reload.pesticide_master_id
  end
end
