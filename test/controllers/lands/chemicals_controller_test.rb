require "test_helper"

class Lands::ChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "田植えの薬剤種別を usual 順に表示する" do
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types1), work_kind: work_kinds(:work_kind_taue))
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types0), work_kind: work_kinds(:work_kind_taue))

    get lands_chemicals_path

    assert_response :success
    assert_select "input[type=radio][name=chemical_type_id][value=?]", chemical_types(:chemical_types0).id.to_s, 1
    assert_select "input[type=radio][name=chemical_type_id][value=?]", chemical_types(:chemical_types1).id.to_s, 1
    assert_select "label", text: chemical_types(:chemical_types0).name
    assert_select "label", text: chemical_types(:chemical_types1).name
    assert_match(/#{Regexp.escape(chemical_types(:chemical_types0).name)}.*#{Regexp.escape(chemical_types(:chemical_types1).name)}/m, @response.body)
    assert_select "input[type=radio][name=chemical_type_id][checked=checked][value=?]", chemical_types(:chemical_types0).id.to_s, 1
  end

  test "選択された薬剤種別を保持する" do
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types1), work_kind: work_kinds(:work_kind_taue))
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types0), work_kind: work_kinds(:work_kind_taue))

    get lands_chemicals_path, params: { chemical_type_id: chemical_types(:chemical_types1).id }

    assert_response :success
    assert_select "input[type=radio][name=chemical_type_id][checked=checked][value=?]", chemical_types(:chemical_types1).id.to_s, 1
  end

  test "当期の田植え圃場を薬剤比較色で地図表示する" do
    ChemicalKind.create!(chemical_type: chemical_types(:chemical_types0), work_kind: work_kinds(:work_kind_taue))

    taue_work = Work.create!(
      term: users(:users1).term,
      worked_at: Date.new(2015, 5, 1),
      weather_id: :sunny,
      work_type_id: 11,
      work_kind: work_kinds(:work_kind_taue),
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )
    other_kind_work = Work.create!(
      term: users(:users1).term,
      worked_at: Date.new(2015, 5, 3),
      weather_id: :sunny,
      work_type_id: 11,
      work_kind: work_kinds(:work_kinds2),
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )

    map_land = lands(:lands1)
    excluded_land = Land.create!(
      place: "9999-1",
      owner: homes(:home1),
      manager: homes(:home1),
      area: 10.0,
      target_flag: true,
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )

    LandCost.create!(land: map_land, work_type: work_types(:work_type_koshi), activated_on: Date.new(2015, 1, 1))
    LandCost.create!(land: excluded_land, work_type: work_types(:work_type_koshi), activated_on: Date.new(2015, 1, 1))

    chemical = Chemical.create!(chemical_type: chemical_types(:chemical_types0), name: "試験表示薬剤", phonetic: "しけんひょうじやくざい", display_order: 999)
    chemical_term = ChemicalTerm.create!(chemical: chemical, term: 2015)
    ChemicalWorkType.create!(chemical_term: chemical_term, work_type: work_types(:work_type_koshi), quantity: 1.0)

    WorkLand.create!(work: taue_work, land: map_land, work_type_id: 11)
    WorkLand.create!(work: other_kind_work, land: excluded_land, work_type_id: 11)
    WorkChemical.create!(work: taue_work, chemical: chemical, quantity: 4.0)
    WorkChemical.create!(work: other_kind_work, chemical: chemical, quantity: 4.0)

    get lands_chemicals_path

    assert_response :success
    assert_select "#map", 1
    assert_select "input[type=hidden][name=regions][data-id='#{map_land.id}'][data-color='#ff4d4f']", 1
    assert_select "input[type=hidden][name=regions][data-id='#{map_land.id}'][data-actual]", 1
    assert_select "input[type=hidden][name=regions][data-id='#{excluded_land.id}']", 0
  end
end
