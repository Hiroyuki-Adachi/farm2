require "test_helper"

class HarvestRices::MapServiceTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @system = systems(:s2015)
    @date = Date.new(2015, 9, 20)
  end

  test "日付と品種単位で世帯の収量を合計し面積から60kg換算する" do
    first = create_land("rice-A", 10)
    second = create_land("rice-B", 30)
    add_work(@date, [first, second])
    add_drying(@date, 32)
    add_drying(@date, 32, home: homes(:home1))

    summaries = result
    assert_equal 8, summaries.fetch(first.id).bales
    assert_equal 8, summaries.fetch(second.id).bales
    assert_equal "#34c759", summaries.fetch(first.id).color
  end

  test "複数日の収量は相加平均し同日の日報重複は面積を増やさない" do
    land = create_land("rice-C", 10)
    add_work(@date, [land])
    add_work(@date, [land])
    add_work(@date + 1, [land])
    add_drying(@date, 14)
    add_drying(@date + 1, 18)

    assert_equal 8, result.fetch(land.id).bales
  end

  test "品種ごとに収量を分離し収穫量のない日と面積ゼロを除外する" do
    rice = create_land("rice-D", 10)
    other = create_land("rice-E", 10, work_type_id: 11)
    empty = create_land("rice-F", 0)
    unharvested = create_land("rice-G", 10)
    add_work(@date, [rice, other, empty])
    add_work(@date + 1, [unharvested])
    add_drying(@date, 16)

    assert_not result.key?(empty.id)
    assert_not result.key?(other.id)
    assert_not result.key?(unharvested.id)
    assert_equal 8, result.fetch(rice.id).bales
  end

  test "他年度と他組織の収量を含めない" do
    land = create_land("rice-H", 10)
    add_work(@date, [land])
    add_drying(@date, 16)
    add_drying(@date, 90, home: homes(:home_other_org))
    previous = add_drying(@date + 1, 90)
    previous.update!(term: 2014)
    add_work(@date + 1, [land])

    assert_equal 8, result.fetch(land.id).bales
  end

  test "カントリーの重量も使用し平均の後に四捨五入する" do
    land = create_land("rice-I", 10)
    add_work(@date, [land])
    drying = add_drying(@date, 0)
    drying.update!(drying_type_id: :country)
    drying.drying_moths.create!(moth_count: 1, rice_weight: 450)

    assert_equal 8, result.fetch(land.id).bales
  end

  test "面積ゼロだけの収穫は除外する" do
    land = create_land("rice-J", 0)
    add_work(@date, [land])
    add_drying(@date, 16)
    assert_not result.key?(land.id)
  end

  test "収穫日以前の最新の品種履歴を使い未来の履歴を除外する" do
    land = create_land("rice-history", 10)
    land.land_costs.create!(activated_on: @date, work_type_id: 11)
    land.land_costs.create!(activated_on: @date + 1, work_type_id: 15)
    add_work(@date - 1, [land])
    add_work(@date, [land])
    add_drying(@date - 1, 14)
    add_drying(@date, 18).update!(work_type_id: 11)

    assert_equal 8, result.fetch(land.id).bales
  end

  test "収穫日時点に品種履歴がない圃場は含めない" do
    land = create_land("rice-future", 10)
    land.land_costs.first.update!(activated_on: @date + 1)
    add_work(@date, [land])
    add_drying(@date, 16)

    assert_not result.key?(land.id)
  end

  test "圃場と日報が増えても同一バッチの品種履歴取得クエリは増えない" do
    land = create_land("rice-query-1", 10)
    add_work(@date, [land])
    add_drying(@date, 16)
    first_count = land_cost_query_count
    more_lands = Array.new(5) { |i| create_land("rice-more-#{i}", 10) }
    add_work(@date, more_lands)
    add_work(@date + 1, [land, *more_lands])

    assert_operator first_count, :>, 0
    assert_equal first_count, land_cost_query_count
  end

  private

  def land_cost_query_count
    count = 0
    subscriber = lambda do |*args|
      payload = args.last
      count += 1 if payload[:sql].match?(/SELECT.*"land_costs"/m)
    end
    ActiveRecord::Base.uncached do
      ActiveSupport::Notifications.subscribed(subscriber, "sql.active_record") { result }
    end
    count
  end

  def result
    HarvestRices::MapService.call(organization: @organization, system: @system)
  end

  def create_land(place, area, work_type_id: 6)
    land = Land.create!(place: place, area: area, owner: homes(:home1), manager: homes(:home1), target_flag: true)
    land.land_costs.create!(activated_on: Date.new(2015, 1, 1), work_type_id: work_type_id)
    land
  end

  def add_work(date, lands)
    work = Work.create!(term: 2015, worked_at: date, weather_id: :sunny, work_type_id: 6,
                        work_kind_id: @organization.harvesting_work_kind_id, start_at: "08:00",
                        end_at: "17:00", name: "", remarks: "")
    lands.each { |land| WorkLand.create!(work: work, land: land, work_type_id: 6) }
  end

  def add_drying(date, bags, home: dryings(:drying2).home)
    drying = Drying.create!(term: 2015, carried_on: date, home: home, work_type_id: 6, drying_type_id: :self)
    drying.create_adjustment!(home: home, rice_bag: bags)
    drying
  end
end
