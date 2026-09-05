require "test_helper"

class Sorimachi::WorkTypeAllocationServiceTest < ActiveSupport::TestCase
  test "決済日ベースで面積按分して作業分類を作成する" do
    system = create_system(term: 2091)
    work_type1 = create_cost_work_type(term: 2091, name: "配賦A")
    work_type2 = create_cost_work_type(term: 2091, name: "配賦B")
    land1 = create_land(place: "A-1", area: 5, organization_id: system.organization_id)
    land2 = create_land(place: "B-1", area: 3, organization_id: system.organization_id)
    LandCost.create!(land_id: land1.id, work_type_id: work_type1.id, activated_on: system.start_date)
    LandCost.create!(land_id: land2.id, work_type_id: work_type2.id, activated_on: system.start_date)
    service = Sorimachi::WorkTypeAllocationService.new(term: 2091, system: system)
    journal = create_journal(term: 2091, line: 9901, accounted_on: Date.new(2091, 5, 1))

    records = service.allocate!(journal: journal, amount: 800, accounted_on: journal.accounted_on)

    assert_equal 2, records.count
    assert_equal 800, records.sum { |record| record.amount.to_i }
    assert_equal 500, records.find_by(work_type_id: work_type1.id).amount.to_i
    assert_equal 300, records.find_by(work_type_id: work_type2.id).amount.to_i
  end

  test "決算は年度全体の面積で按分する" do
    system = create_system(term: 2092)
    work_type1 = create_cost_work_type(term: 2092, name: "年配賦A")
    work_type2 = create_cost_work_type(term: 2092, name: "年配賦B")
    land1 = create_land(place: "A-2", area: 10, organization_id: system.organization_id)
    land2 = create_land(place: "B-2", area: 5, organization_id: system.organization_id)
    LandCost.create!(land_id: land1.id, work_type_id: work_type1.id, activated_on: system.start_date)
    LandCost.create!(land_id: land1.id, work_type_id: work_type2.id, activated_on: Date.new(2092, 7, 1))
    LandCost.create!(land_id: land2.id, work_type_id: work_type2.id, activated_on: system.start_date)
    service = Sorimachi::WorkTypeAllocationService.new(term: 2092, system: system)
    journal = create_journal(term: 2092, line: 9902, accounted_on: nil)

    records = service.allocate!(journal: journal, amount: 219, accounted_on: nil)

    assert_equal 2, records.count
    assert_equal 219, records.sum { |record| record.amount.to_i }
    assert_equal 73, records.find_by(work_type_id: work_type1.id).amount.to_i
    assert_equal 146, records.find_by(work_type_id: work_type2.id).amount.to_i
  end

  test "端数が同額時は作業分類ID最小へ加算する" do
    system = create_system(term: 2093)
    work_type1 = create_cost_work_type(term: 2093, name: "端数A")
    work_type2 = create_cost_work_type(term: 2093, name: "端数B")
    land1 = create_land(place: "A-3", area: 1, organization_id: system.organization_id)
    land2 = create_land(place: "B-3", area: 1, organization_id: system.organization_id)
    LandCost.create!(land_id: land1.id, work_type_id: work_type1.id, activated_on: system.start_date)
    LandCost.create!(land_id: land2.id, work_type_id: work_type2.id, activated_on: system.start_date)
    service = Sorimachi::WorkTypeAllocationService.new(term: 2093, system: system)
    journal = create_journal(term: 2093, line: 9903, accounted_on: Date.new(2093, 6, 1))

    records = service.allocate!(journal: journal, amount: 1, accounted_on: journal.accounted_on)

    assert_equal 1, records.count
    assert_equal 1, records.sum { |record| record.amount.to_i }
    assert_nil records.find_by(work_type_id: work_type1.id)
    assert_equal 1, records.find_by(work_type_id: work_type2.id).amount.to_i
  end

  test "他組織の土地は面積按分に混ぜない" do
    system = create_system(term: 2094)
    other_system = create_system(term: 2094)
    work_type1 = create_cost_work_type(term: 2094, name: "越境配賦A")
    work_type2 = create_cost_work_type(term: 2094, name: "越境配賦B")
    land1 = create_land(place: "A-4", area: 5, organization_id: system.organization_id)
    other_land = create_land(place: "X-4", area: 95, organization_id: other_system.organization_id)
    LandCost.create!(land_id: land1.id, work_type_id: work_type1.id, activated_on: system.start_date)
    LandCost.create!(land_id: other_land.id, work_type_id: work_type2.id, activated_on: other_system.start_date)
    service = Sorimachi::WorkTypeAllocationService.new(term: 2094, system: system)
    journal = create_journal(term: 2094, line: 9904, accounted_on: Date.new(2094, 6, 1))

    records = service.allocate!(journal: journal, amount: 100, accounted_on: journal.accounted_on)

    assert_equal 1, records.count
    assert_equal 100, records.find_by(work_type_id: work_type1.id).amount.to_i
    assert_nil records.find_by(work_type_id: work_type2.id)
  end

  private

  def create_system(term:)
    organization = Organization.create!(name: "配賦テスト#{term}", term: term)
    System.create!(
      term: term,
      term_name: term.to_s,
      start_date: Date.new(term, 1, 1),
      end_date: Date.new(term, 12, 31),
      organization_id: organization.id
    )
  end

  def create_cost_work_type(term:, name:)
    work_type = WorkType.create!(
      genre: work_genres(:genre_change),
      name: name,
      display_order: 999,
      land_flag: true,
      cost_flag: true
    )
    WorkTypeTerm.create!(term: term, work_type_id: work_type.id)
    work_type
  end

  def create_land(place:, area:, organization_id:)
    home = home_for_organization(organization_id)
    Land.create!(
      place: place,
      area: area,
      target_flag: true,
      organization_id: organization_id,
      owner_id: home.id,
      manager_id: home.id,
      start_on: Date.new(1900, 1, 1),
      end_on: Date.new(2999, 12, 31)
    )
  end

  def home_for_organization(organization_id)
    @homes_by_organization ||= {}
    @homes_by_organization[organization_id] ||= begin
      section = Section.create!(name: "配賦テスト班#{organization_id}", display_order: 1, organization_id: organization_id)
      Home.create!(
        name: "配賦テスト世帯#{organization_id}",
        phonetic: "はいふてすと",
        display_order: 1,
        organization_id: organization_id,
        section: section
      )
    end
  end

  def create_journal(term:, line:, accounted_on:)
    src = sorimachi_journals(:journal1)
    SorimachiJournal.create!(
      src.attributes.except("id", "created_at", "updated_at").merge(
        term: term,
        line: line,
        detail: 1,
        accounted_on: accounted_on
      )
    )
  end
end
