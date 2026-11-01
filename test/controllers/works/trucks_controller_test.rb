require "test_helper"

class Works::TrucksControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @truck_type = machine_types(:machine_types_removable)
    organizations(:org).update!(truck_id: @truck_type.id)
    create_truck(homes(:home1))
    create_truck(homes(:home6))
    MachineKind.create!(machine_type: @truck_type, work_kind: work_kinds(:work_kind_shirokaki))
    MachineKind.create!(machine_type: @truck_type, work_kind: work_kinds(:work_kind_taue))
    @truck_work_type = work_types(:work_type_koshi)
  end

  test "自家用車機械種別が未設定の場合は 503 を返す" do
    organizations(:org).update!(truck_id: nil)

    get works_trucks_path

    assert_response :service_unavailable
  end

  test "自家用車の機械種別に紐づく作業種別トグルをカナ順に表示する" do
    work_kinds(:work_kind_shirokaki).update!(display_order: 20)
    work_kinds(:work_kind_taue).update!(display_order: 10)

    get works_trucks_path

    assert_response :success
    assert_select "#truck-work-kind-tabs a", 3
    assert_select "#truck-work-kind-tabs a:nth-child(2)", work_kinds(:work_kind_shirokaki).name
    assert_select "#truck-work-kind-tabs a:nth-child(3)", work_kinds(:work_kind_taue).name
    assert_select "#truck-work-kind-tabs a:first-child.btn-primary", "全て"
  end

  test "作業種別パラメータで選択状態を切り替える" do
    get works_trucks_path, params: { work_kind_id: work_kinds(:work_kind_taue).id }

    assert_response :success
    assert_select "#truck-work-kind-tabs a.btn-primary", work_kinds(:work_kind_taue).name
  end

  test "自家用車利用一覧に月トグルを表示する" do
    travel_to Date.new(2015, 6, 15) do
      get works_trucks_path
    end

    assert_response :success
    assert_select "#truck-month-tabs a", 13
    assert_select "#truck-month-tabs a.btn-primary", "6月"
  end

  test "当月が期外の場合は期首月を初期選択する" do
    travel_to Date.new(2026, 5, 17) do
      get works_trucks_path
    end

    assert_response :success
    assert_select "#truck-month-tabs a.btn-primary", "1月"
  end

  test "月パラメータで選択月を切り替える" do
    get works_trucks_path, params: { month: "2015-04-01" }

    assert_response :success
    assert_select "#truck-month-tabs a.btn-primary", "4月"
  end

  test "選択した作業種別と月の作業を日付順に表示する" do
    later_work = create_work(Date.new(2015, 2, 10), work_kinds(:work_kind_shirokaki))
    earlier_work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    excluded_month_work = create_work(Date.new(2015, 3, 1), work_kinds(:work_kind_shirokaki))
    excluded_kind_work = create_work(Date.new(2015, 2, 6), work_kinds(:work_kind_taue))

    get works_trucks_path, params: { work_kind_id: work_kinds(:work_kind_shirokaki).id, month: "2015-02-01" }

    assert_response :success
    assert_select "tbody tr td", text: earlier_work.decorate.worked_at_long
    assert_select "tbody tr td", text: later_work.decorate.worked_at_long
    assert_select "tbody tr td", text: excluded_month_work.decorate.worked_at_long, count: 0
    assert_select "tbody tr td", text: excluded_kind_work.decorate.worked_at_long, count: 0
    assert_includes response.body, earlier_work.decorate.work_type_name
    assert_operator response.body.index(earlier_work.decorate.worked_at_long), :<,
                    response.body.index(later_work.decorate.worked_at_long)
  end

  test "自家用車を所有する班を表示して全てを初期選択する" do
    get works_trucks_path

    assert_response :success
    assert_select "#truck-section-tabs a", 3
    assert_select "#truck-section-tabs a:first-child.btn-primary", "全て"
    assert_select "th", text: homes(:home1).name
    assert_select "th", text: homes(:home6).name
  end

  test "班パラメータで自家用車列を絞り込む" do
    get works_trucks_path, params: { section_id: sections(:sections1).id }

    assert_response :success
    assert_select "#truck-section-tabs a.btn-primary", sections(:sections1).name
    assert_select "th", text: homes(:home1).name, count: 0
    assert_select "th", text: homes(:home6).name
  end

  test "稼働期間が選択月と重ならないトラックは列を表示しない" do
    other_home_truck = create_truck(
      homes(:home2),
      validity_start_at: Date.new(2015, 3, 1),
      validity_end_at: Date.new(2015, 3, 31)
    )

    get works_trucks_path, params: { month: "2015-02-01" }

    assert_response :success
    assert_select "th", text: other_home_truck.owner.name, count: 0
  end

  test "稼働期間が選択月の一部と重なるトラックは列を表示する" do
    other_home_truck = create_truck(
      homes(:home2),
      validity_start_at: Date.new(2015, 2, 20),
      validity_end_at: Date.new(2015, 3, 10)
    )

    get works_trucks_path, params: { month: "2015-02-01" }

    assert_response :success
    assert_select "th", text: other_home_truck.owner.name
  end

  test "稼働期間外の作業日には入力欄を表示しない" do
    active_work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    inactive_work = create_work(Date.new(2015, 2, 15), work_kinds(:work_kind_shirokaki))
    health = Health.create!(code: "T", name: "良好", display_order: 999, well_flag: true)
    active_result = WorkResult.create!(
      work: active_work, worker: workers(:worker1), health: health, hours: 1.0, display_order: 1
    )
    inactive_result = WorkResult.create!(
      work: inactive_work, worker: workers(:worker1), health: health, hours: 1.0, display_order: 1
    )
    truck = create_truck(homes(:home1), validity_start_at: Date.new(2015, 2, 1), validity_end_at: Date.new(2015, 2, 10))

    get works_trucks_path, params: { work_kind_id: work_kinds(:work_kind_shirokaki).id, month: "2015-02-01" }

    assert_response :success
    assert_select "input[name='machine_hours[#{truck.id}][#{active_result.id}]']", 1
    assert_select "input[name='machine_hours[#{truck.id}][#{inactive_result.id}]']", 0
  end

  test "全てでは当期の対象作業種別の作業だけを日付順に表示する" do
    later_work = create_work(Date.new(2015, 12, 31), work_kinds(:work_kind_taue))
    earlier_work = create_work(Date.new(2015, 1, 1), work_kinds(:work_kind_shirokaki))
    previous_work = create_work(Date.new(2014, 12, 31), work_kinds(:work_kind_shirokaki))
    next_work = create_work(Date.new(2016, 1, 1), work_kinds(:work_kind_taue))
    excluded_kind = WorkKind.where.not(id: @truck_type.work_kind_ids).first!
    excluded_work = create_work(Date.new(2015, 7, 1), excluded_kind)

    get works_trucks_path, params: { month: "all" }

    assert_response :success
    [earlier_work, later_work].each do |work|
      assert_select "tbody tr td", text: work.decorate.worked_at_long
    end
    [previous_work, next_work, excluded_work].each do |work|
      assert_select "tbody tr td", text: work.decorate.worked_at_long, count: 0
    end
    assert_operator response.body.index(earlier_work.decorate.worked_at_long), :<,
                    response.body.index(later_work.decorate.worked_at_long)
  end

  test "年月が全ての場合は期内に稼働期間が重なる車両を表示する" do
    truck = create_truck(
      homes(:home2), validity_start_at: Date.new(2015, 12, 31), validity_end_at: Date.new(2016, 2, 1)
    )

    get works_trucks_path, params: { month: "all" }

    assert_response :success
    assert_select "th", text: truck.owner.name

    truck.update!(validity_start_at: Date.new(2016, 1, 1))
    get works_trucks_path, params: { month: "all" }

    assert_select "th", text: truck.owner.name, count: 0
  end

  test "年月が全ての場合は稼働期間外でも対象の利用実績がある車両を表示する" do
    truck = create_truck(
      homes(:home2), validity_start_at: Date.new(2014, 1, 1), validity_end_at: Date.new(2014, 12, 31)
    )
    work = create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))
    health = Health.create!(code: "T", name: "良好", display_order: 999, well_flag: true)
    result = WorkResult.create!(work: work, worker: workers(:worker2), health: health, hours: 1, display_order: 1)
    MachineResult.create!(machine: truck, work_result: result, hours: 2.5)

    get works_trucks_path, params: { month: "all" }

    assert_response :success
    assert_select "th", text: truck.owner.name
    assert_select "input[name='machine_hours[#{truck.id}][#{result.id}]'][value='2.5']", 1
  end

  test "対象作業種別が未設定なら全てでも作業を表示しない" do
    @truck_type.machine_kinds.destroy_all
    create_work(Date.new(2015, 2, 5), work_kinds(:work_kind_shirokaki))

    get works_trucks_path, params: { month: "all" }

    assert_response :success
    assert_select "tbody tr", 0
  end

  private

  def create_work(worked_at, work_kind)
    Work.create!(
      term: 2015,
      worked_at: worked_at,
      weather_id: :sunny,
      work_type: @truck_work_type,
      work_kind: work_kind,
      name: "",
      remarks: "",
      start_at: Time.zone.local(2015, 2, 1, 8, 0, 0),
      end_at: Time.zone.local(2015, 2, 1, 17, 0, 0),
      organization: organizations(:org)
    )
  end

  def create_truck(home, validity_start_at: Date.new(2015, 1, 1), validity_end_at: Date.new(2099, 12, 31))
    Machine.create!(
      name: "",
      display_order: 1,
      validity_start_at: validity_start_at,
      validity_end_at: validity_end_at,
      machine_type_id: @truck_type.id,
      home_id: home.id,
      diesel_flag: false
    )
  end
end
