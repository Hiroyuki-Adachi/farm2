require "test_helper"

class Tablets::Lands::ChemicalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "タブレット版の農薬散布地図を表示する" do
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

    map_land = lands(:lands1)
    LandCost.create!(land: map_land, work_type: work_types(:work_type_koshi), activated_on: Date.new(2015, 1, 1))

    chemical = Chemical.create!(chemical_type: chemical_types(:chemical_types0), name: "試験表示薬剤T", phonetic: "しけんひょうじやくざいてぃ", display_order: 999)
    chemical_term = ChemicalTerm.create!(chemical: chemical, term: 2015)
    ChemicalWorkType.create!(chemical_term: chemical_term, work_type: work_types(:work_type_koshi), quantity: 1.0)

    WorkLand.create!(work: taue_work, land: map_land, work_type_id: 11)
    WorkChemical.create!(work: taue_work, chemical: chemical, quantity: 4.0)

    get tablets_lands_chemicals_path

    assert_response :success
    assert_select "#map", 1
    assert_select "label.btn.btn-outline-primary.btn-lg", text: chemical_types(:chemical_types0).name
    assert_select "input[type=hidden][name=regions][data-id='#{map_land.id}'][data-color='#ff4d4f']", 1
  end
end
