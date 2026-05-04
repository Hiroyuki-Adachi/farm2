# == Schema Information
#
# Table name: works(作業データ)
#
#  id(作業データ)                          :integer          not null, primary key
#  chemical_group_flag(薬剤グループフラグ) :boolean          default(FALSE), not null
#  created_by(作成者)                      :integer
#  end_at(終了時刻)                        :time             not null
#  fixed_at(確定日)                        :date
#  name(作業名称)                          :string(40)       not null
#  printed_at(印刷日時)                    :datetime
#  printed_by(印刷者)                      :integer
#  remarks(備考)                           :text
#  start_at(開始時刻)                      :time             not null
#  term(年度(期))                          :integer          not null
#  worked_at(作業日)                       :date             not null
#  created_at                              :datetime
#  updated_at                              :datetime
#  organization_id(組織)                   :bigint           default(1), not null
#  weather_id(天気)                        :integer
#  work_kind_id(作業種別)                  :integer          default(0), not null
#  work_type_id(作業分類)                  :integer
#
# Indexes
#
#  index_works_on_organization_id           (organization_id)
#  index_works_on_organization_id_and_term  (organization_id,term)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  setup do
    @work = works(:work_for_price)
    @sum_hours = work_results(:work_result_for_price1).hours + work_results(:work_result_for_price2).hours
    @sum_areas = lands(:lands0).area + lands(:lands1).area
  end

  test "作業者数" do
    assert_equal 2, @work.workers_count
  end

  test "作業時間" do
    assert_equal @sum_hours, @work.sum_hours
  end

  test "作業面積" do
    assert_equal @sum_areas, @work.sum_areas
  end

  test "作業単価" do
    assert_equal @work.term, @work.price
  end

  test "作業金額合計" do
    assert_equal @work.term * @sum_hours, @work.sum_workers_amount
  end

  test "工数統計_総合計" do
    total_hours = Work.joins(:work_results).where(term: 2015).sum("work_results.hours")
    assert_equal total_hours, Work.total_all([2015])[2015]
  end

  test "工数統計_ジャンル別" do
    total_hours = Work.joins(:work_results)
        .joins("INNER JOIN work_types ON works.work_type_id = work_types.id")
        .where(term: 2015, "work_types.work_genre_id" => @work.work_type.work_genre_id)
        .sum("work_results.hours")
    assert_equal total_hours, Work.total_genre[[@work.work_type.work_genre_id, 2015]]
  end

  test "工数統計は組織で絞り込める" do
    work_type = work_types(:work_type_koshi)
    org_work = create_summary_work(
      organization: organizations(:org),
      worker: workers(:worker1),
      work_type: work_type,
      worked_at: Date.new(2026, 1, 15),
      hours: 2
    )
    create_summary_work(
      organization: organizations(:org2),
      worker: workers(:worker1),
      work_type: work_type,
      worked_at: Date.new(2026, 1, 15),
      hours: 7
    )

    assert_equal 2, Work.total_all([2026], organization: organizations(:org))[2026]
    assert_equal 2, Work.total_by_worker(workers(:worker1), 2026, organization: organizations(:org))[2026]
    assert_equal 2.0, Work.total_by_month(nil, 2026, organization: organizations(:org))[0]
    assert_equal 2, Work.total_genre(organization: organizations(:org))[[work_type.work_genre_id, 2026]]
    assert_includes Work.for_organization(organizations(:org)), org_work
  end

  test "世帯別工数統計は組織で絞り込める" do
    same_home_worker = Worker.create!(
      organization: organizations(:org),
      home: workers(:worker1).home,
      family_name: "集計",
      first_name: "太郎",
      family_phonetic: "しゅうけい",
      first_phonetic: "たろう",
      display_order: 99
    )
    create_summary_work(
      organization: organizations(:org),
      worker: same_home_worker,
      worked_at: Date.new(2026, 1, 15),
      hours: 3
    )
    create_summary_work(
      organization: organizations(:org2),
      worker: same_home_worker,
      worked_at: Date.new(2026, 1, 15),
      hours: 8
    )

    assert_equal 3, Work.total_by_home(workers(:worker1), 2026, organization: organizations(:org))[2026]
  end

  test "年度別作業効率_10aあたり時間" do
    work_kind = WorkKind.new(
      name: "効率",
      phonetic: "こうりつ",
      display_order: 999,
      cost_type: cost_types(:cost_types1),
      aggregation_flag: true
    )
    work_kind.term = 2015
    work_kind.price = 1000
    work_kind.save!

    work = Work.create!(
      organization: organizations(:org),
      term: 2015,
      worked_at: Date.new(2015, 5, 1),
      weather_id: :sunny,
      work_type: work_types(:work_type_koshi),
      work_kind: work_kind,
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )
    WorkResult.create!(work: work, worker: workers(:worker1), hours: 2.0, display_order: 1)
    WorkResult.create!(work: work, worker: workers(:worker2), hours: 3.0, display_order: 2)
    WorkLand.create!(work: work, land: lands(:lands0), display_order: 1)
    WorkLand.create!(work: work, land: lands(:lands1), display_order: 2)

    other_organization_work = Work.create!(
      organization: organizations(:org2),
      term: 2015,
      worked_at: Date.new(2015, 5, 2),
      weather_id: :sunny,
      work_type: work_types(:work_type_koshi),
      work_kind: work_kind,
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )
    WorkResult.create!(work: other_organization_work, worker: workers(:worker1), hours: 10.0, display_order: 1)
    WorkLand.create!(work: other_organization_work, land: lands(:lands0), display_order: 1)
    zero_area_land = Land.create!(
      place: "効率0",
      owner: homes(:home1),
      manager: homes(:home1),
      area: 0,
      target_flag: true
    )
    zero_area_work = Work.create!(
      organization: organizations(:org),
      term: 2015,
      worked_at: Date.new(2015, 5, 3),
      weather_id: :sunny,
      work_type: work_types(:work_type_koshi),
      work_kind: work_kind,
      name: "",
      remarks: "",
      start_at: "08:00",
      end_at: "17:00"
    )
    WorkResult.create!(work: zero_area_work, worker: workers(:worker3), hours: 10.0, display_order: 1)
    WorkLand.create!(work: zero_area_work, land: zero_area_land, display_order: 1)

    results = Work.hours_per_10a_by_work_kind(work_kind.id, [2014, 2015], organization: organizations(:org))

    assert_equal 0, results[2014]
    assert_equal 0.75, results[2015]
  end

  test "作業種別キャッシュ" do
    w = works(:work_for_work_type_cache)
    w.regist_work_work_types
    wts = w.work_types.order(id: :asc)
    assert_equal wts.count, 2
    assert wts.ids.include?(land_costs(:land_cost_genka1).work_type_id)
    assert wts.ids.include?(land_costs(:land_cost_genka21).work_type_id)
  end

  test "作業者登録" do
    old_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker1).id)
    params = ActionController::Parameters.new(
      {
        results: 
          [
            {worker_id: workers(:worker1).id, hours: 1.5, display_order: 1},
            {worker_id: workers(:worker4).id, hours: 4.5, display_order: 2}
          ]
      }
    )
    @work.regist_results(params[:results], workers(:worker3))
    assert_equal params[:results].size, @work.work_results.count

    # 更新データの確認
    updated_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker1).id)
    assert_not_equal old_result.updated_at, updated_result.updated_at
    assert_equal 1.5, updated_result.hours
    assert_equal 1, updated_result.display_order

    # 作成データの確認
    created_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker4).id)
    assert_not_nil created_result
    assert_equal 4.5, created_result.hours
    assert_equal 2, created_result.display_order

    # 削除データの確認
    deleted_result = WorkResult.find_by(work_id: @work.id, worker_id: workers(:worker2).id)
    assert_nil deleted_result

    # 印刷情報のクリア確認
    assert_nil @work.printed_at
    assert_nil @work.printed_by
  end

  test "農地登録" do
    old_work_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands0).id)
    params = ActionController::Parameters.new(
      {
        work_lands: 
          [
            {land_id: lands(:lands0).id, display_order: 1},
            {land_id: lands(:lands3).id, display_order: 2}
          ]
      }
    )

    @work.regist_lands(params[:work_lands])
    assert_equal params[:work_lands].size, @work.work_lands.count

    # 更新データの確認
    updated_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands0).id)
    assert_equal old_work_land.updated_at, updated_land.updated_at

    # 作成データの確認
    created_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands3).id)
    assert_not_nil created_land
    assert_equal 2, created_land.display_order

    # 削除データの確認
    deleted_land = WorkLand.find_by(work_id: @work.id, land_id: lands(:lands1).id)
    assert_nil deleted_land
  end

  test "機械登録" do
    params = ActionController::Parameters.new(
      {
        machine_hours:
          {
            machines(:machine_hour_t).id.to_s => {work_results(:work_result_for_price1).id.to_s => 2.5},
            machines(:machine_area_t).id.to_s => {work_results(:work_result_for_price2).id.to_s => 3.0},
            machines(:machine_day_t).id.to_s => {work_results(:work_result_for_price2).id.to_s => 0}
          }
      }
    )

    @work.regist_machines(params[:machine_hours])
    assert_equal 2, @work.machine_results.count

    # 更新データの確認
    updated_machine = MachineResult.find_by(work_result_id: work_results(:work_result_for_price1).id, machine_id: machines(:machine_hour_t).id)
    assert_equal 2.5, updated_machine.hours

    # 作成データの確認
    created_machine = MachineResult.find_by(work_result_id: work_results(:work_result_for_price2).id, machine_id: machines(:machine_area_t).id)
    assert_not_nil created_machine
    assert_equal 3.0, created_machine.hours

    # 削除データの確認
    deleted_machine = MachineResult.find_by(work_result_id: work_results(:work_result_for_price2).id, machine_id: machines(:machine_day_t).id)
    assert_nil deleted_machine
  end

  test "機械登録で別作業の作業結果は更新しない" do
    other_machine_result = machine_results(:machine_result_genka1)
    params = ActionController::Parameters.new(
      {
        machine_hours:
          {
            machines(:machine_hour_t).id.to_s => {work_results(:work_result_genka1).id.to_s => 0}
          }
      }
    )

    @work.regist_machines(params[:machine_hours])

    assert MachineResult.exists?(other_machine_result.id)
    assert_equal 3, other_machine_result.reload.hours
  end

  test "農薬登録" do
    work = works(:work_chemical_test)
    existing = work_chemicals(:work_chemical_test)
    params = ActionController::Parameters.new(
      {
        chemicals:
          {
            chemicals(:chemical_amistar).id.to_s => {
              "1" => {quantity: 150, dilution_id: 2, magnification: 1000, remarks: "updated"}
            },
            chemicals(:chemical_genka).id.to_s => {
              "1" => {quantity: 5, dilution_id: 1, magnification: 500, remarks: "created"}
            }
          }
      }
    )

    work.regist_chemicals(params[:chemicals])

    assert_equal 2, work.work_chemicals.count
    assert_equal 150, existing.reload.quantity
    created = WorkChemical.find_by!(work: work, chemical: chemicals(:chemical_genka), chemical_group_no: 1)
    assert_equal 5, created.quantity
    assert_equal "created", created.remarks
  end

  test "農薬登録で数量0は削除する" do
    work = works(:work_chemical_test)
    existing = work_chemicals(:work_chemical_test)
    params = ActionController::Parameters.new(
      {
        chemicals:
          {
            chemicals(:chemical_amistar).id.to_s => {
              "1" => {quantity: 0, dilution_id: 2, magnification: 1000, remarks: ""}
            }
          }
      }
    )

    work.regist_chemicals(params[:chemicals])

    assert_not WorkChemical.exists?(existing.id)
  end

  test "作業検索条件" do
    work_type = work_types(:work_type_koshi)
    other_work_type = work_types(:work_type_broccoli)
    work_kind = work_kinds(:work_kind_every_term)
    other_work_kind = work_kinds(:work_kind_broccoli)

    target = create_search_work(work_type: work_type, work_kind: work_kind, worked_at: Date.new(2026, 1, 15))
    other_type = create_search_work(work_type: other_work_type, work_kind: work_kind, worked_at: Date.new(2026, 1, 15))
    other_kind = create_search_work(work_type: work_type, work_kind: other_work_kind, worked_at: Date.new(2026, 1, 15))
    out_of_range = create_search_work(work_type: work_type, work_kind: work_kind, worked_at: Date.new(2026, 2, 1))
    base = Work.where(id: [target.id, other_type.id, other_kind.id, out_of_range.id])
    params = ActionController::Parameters.new(
      work_type_id: work_type.id,
      work_kind_id: work_kind.id,
      worked_at1: Date.new(2026, 1, 1),
      worked_at2: Date.new(2026, 1, 31)
    )

    assert_equal [target.id], Work.search_for_work(base, params).pluck(:id)
  end

  test "作業検索条件で作業分類を除外する" do
    work_type = work_types(:work_type_koshi)
    other_work_type = work_types(:work_type_broccoli)
    work_kind = work_kinds(:work_kind_every_term)

    excluded = create_search_work(work_type: work_type, work_kind: work_kind, worked_at: Date.new(2026, 1, 15))
    included = create_search_work(work_type: other_work_type, work_kind: work_kind, worked_at: Date.new(2026, 1, 15))
    base = Work.where(id: [excluded.id, included.id])
    params = ActionController::Parameters.new(work_type_id: work_type.id, except: "1")

    assert_equal [included.id], Work.search_for_work(base, params).pluck(:id)
  end

  private

  def create_search_work(work_type:, work_kind:, worked_at:)
    Work.create!(
      organization: organizations(:org),
      term: worked_at.year,
      worked_at: worked_at,
      weather_id: :sunny,
      work_type: work_type,
      work_kind: work_kind,
      name: "検索条件テスト",
      start_at: "08:00",
      end_at: "17:00"
    )
  end

  def create_summary_work(organization:, worker:, worked_at:, hours:, work_type: work_types(:work_type_koshi))
    work = Work.create!(
      organization: organization,
      term: worked_at.year,
      worked_at: worked_at,
      weather_id: :sunny,
      work_type: work_type,
      work_kind: work_kinds(:work_kind_every_term),
      name: "組織別集計テスト",
      start_at: "08:00",
      end_at: "17:00"
    )
    WorkResult.create!(work: work, worker: worker, hours: hours, display_order: 1)
    work
  end
end
