require "test_helper"

class Lands::ChemicalMapServiceTest < ActiveSupport::TestCase
  test "薬剤対応する作付圃場にだけ配賦し同一作付には加算する" do
    work = Work.create!(
      term: 2015,
      worked_at: Date.new(2015, 5, 10),
      weather_id: :sunny,
      work_type_id: work_types(:work_types9).id,
      work_kind: work_kinds(:work_kind_taue),
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )

    land1 = create_land(place: "A-1", area: 10, region: true)
    land2 = create_land(place: "B-1", area: 20, region: true)
    land3 = create_land(place: "C-1", area: 10, region: true)

    WorkLand.create!(work: work, land: land1, work_type_id: work_types(:work_types9).id)
    WorkLand.create!(work: work, land: land2, work_type_id: work_types(:work_types9).id)
    WorkLand.create!(work: work, land: land3, work_type_id: work_types(:work_types9).id)

    LandCost.create!(land: land1, work_type: work_types(:work_type_koshi), activated_on: Date.new(2015, 1, 1))
    LandCost.create!(land: land2, work_type: work_types(:work_type_bokuso), activated_on: Date.new(2015, 1, 1))
    LandCost.create!(land: land3, work_type: work_types(:work_type_bokuso), activated_on: Date.new(2015, 1, 1))

    chemical1 = create_chemical(name: "試験薬剤あ", phonetic: "しけんやくざいあ")
    chemical2 = create_chemical(name: "試験薬剤い", phonetic: "しけんやくざいい")
    chemical3 = create_chemical(name: "試験薬剤う", phonetic: "しけんやくざいう")

    term1 = ChemicalTerm.create!(chemical: chemical1, term: 2015)
    term2 = ChemicalTerm.create!(chemical: chemical2, term: 2015)
    term3 = ChemicalTerm.create!(chemical: chemical3, term: 2015)

    ChemicalWorkType.create!(chemical_term: term1, work_type: work_types(:work_type_koshi), quantity: 1.0)
    ChemicalWorkType.create!(chemical_term: term2, work_type: work_types(:work_type_koshi), quantity: 0.5)
    ChemicalWorkType.create!(chemical_term: term2, work_type: work_types(:work_type_bokuso), quantity: 1.5)
    ChemicalWorkType.create!(chemical_term: term3, work_type: work_types(:work_type_bokuso), quantity: 2.0)

    WorkChemical.create!(work: work, chemical: chemical1, quantity: 3.0)
    WorkChemical.create!(work: work, chemical: chemical2, quantity: 6.0)
    WorkChemical.create!(work: work, chemical: chemical3, quantity: 6.0)

    summaries = Lands::ChemicalMapService.call(
      term: 2015,
      work_kind_id: work_kinds(:work_kind_taue).id,
      chemical_type_id: chemical_types(:chemical_types0).id
    )

    assert_in_delta 4.5, summaries.fetch(land1.id).actual.to_f, 0.001
    assert_in_delta 1.5, summaries.fetch(land1.id).standard.to_f, 0.001
    assert_equal :over_50, summaries.fetch(land1.id).status

    assert_in_delta 3.5, summaries.fetch(land2.id).actual.to_f, 0.001
    assert_in_delta 3.5, summaries.fetch(land2.id).standard.to_f, 0.001
    assert_equal :within_10, summaries.fetch(land2.id).status

    assert_in_delta 3.5, summaries.fetch(land3.id).actual.to_f, 0.001
    assert_in_delta 3.5, summaries.fetch(land3.id).standard.to_f, 0.001
    assert_equal :within_10, summaries.fetch(land3.id).status
  end

  test "作業地グループがある場合は同じグループの圃場だけで配賦する" do
    work = Work.create!(
      term: 2015,
      worked_at: Date.new(2015, 5, 11),
      weather_id: :sunny,
      work_type_id: work_types(:work_types9).id,
      work_kind: work_kinds(:work_kind_taue),
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00",
      chemical_group_flag: true
    )

    land1 = create_land(place: "G-1", area: 10)
    land2 = create_land(place: "G-2", area: 20)

    WorkLand.create!(work: work, land: land1, work_type_id: work_types(:work_types9).id, chemical_group_no: 1)
    WorkLand.create!(work: work, land: land2, work_type_id: work_types(:work_types9).id, chemical_group_no: 2)

    LandCost.create!(land: land1, work_type: work_types(:work_type_koshi), activated_on: Date.new(2015, 1, 1))
    LandCost.create!(land: land2, work_type: work_types(:work_type_koshi), activated_on: Date.new(2015, 1, 1))

    chemical = create_chemical(name: "試験薬剤え", phonetic: "しけんやくざいえ")
    term = ChemicalTerm.create!(chemical: chemical, term: 2015)
    ChemicalWorkType.create!(chemical_term: term, work_type: work_types(:work_type_koshi), quantity: 1.0)
    WorkChemical.create!(work: work, chemical: chemical, quantity: 2.0, chemical_group_no: 1)

    summaries = Lands::ChemicalMapService.call(
      term: 2015,
      work_kind_id: work_kinds(:work_kind_taue).id,
      chemical_type_id: chemical_types(:chemical_types0).id
    )

    assert_in_delta 2.0, summaries.fetch(land1.id).actual.to_f, 0.001
    assert_in_delta 1.0, summaries.fetch(land1.id).standard.to_f, 0.001
    assert_nil summaries[land2.id]
  end

  test "基準量との差分率を7段階の色に分類する" do
    service = Lands::ChemicalMapService.new(term: 2015, work_kind_id: work_kinds(:work_kind_taue).id, chemical_type_id: chemical_types(:chemical_types0).id)

    assert_equal :over_50, service.send(:status_for, 0.5001.to_d)
    assert_equal :over_25, service.send(:status_for, 0.5.to_d)
    assert_equal :over_10, service.send(:status_for, 0.25.to_d)
    assert_equal :within_10, service.send(:status_for, 0.1.to_d)
    assert_equal :within_10, service.send(:status_for, -0.1.to_d)
    assert_equal :under_10, service.send(:status_for, -0.1001.to_d)
    assert_equal :under_10, service.send(:status_for, -0.25.to_d)
    assert_equal :under_25, service.send(:status_for, -0.2501.to_d)
    assert_equal :under_25, service.send(:status_for, -0.5.to_d)
    assert_equal :under_50, service.send(:status_for, -0.5001.to_d)

    assert_equal "#ff4d4f", Lands::ChemicalMapService::COLORS.fetch(:over_50)
    assert_equal "#ff9500", Lands::ChemicalMapService::COLORS.fetch(:over_25)
    assert_equal "#ffd60a", Lands::ChemicalMapService::COLORS.fetch(:over_10)
    assert_equal "#34c759", Lands::ChemicalMapService::COLORS.fetch(:within_10)
    assert_equal "#64d2ff", Lands::ChemicalMapService::COLORS.fetch(:under_10)
    assert_equal "#0a84ff", Lands::ChemicalMapService::COLORS.fetch(:under_25)
    assert_equal "#003a8c", Lands::ChemicalMapService::COLORS.fetch(:under_50)
  end

  private

  def create_land(place:, area:, region: false)
    attributes = {
      place: place,
      area: area,
      target_flag: true,
      owner_id: homes(:home1).id,
      manager_id: homes(:home1).id,
      start_on: Date.new(1900, 1, 1),
      end_on: Date.new(2999, 12, 31)
    }
    attributes[:region] = "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))" if region
    Land.create!(attributes)
  end

  def create_chemical(name:, phonetic:)
    Chemical.create!(
      chemical_type: chemical_types(:chemical_types0),
      name: name,
      phonetic: phonetic,
      display_order: 999
    )
  end
end
