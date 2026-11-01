require "test_helper"

class WorkTypeSelectionOrganizationScopeControllerTest < ActionDispatch::IntegrationTest
  setup do
    travel_to(Date.new(2015, 1, 1))
    other_organization = organizations(:org2)
    @other_category = WorkCategory.create!(organization: other_organization, name: "別組織区分", display_order: 1)
    other_genre = WorkGenre.create!(category: @other_category, name: "別組織種類", display_order: 1)
    @other_work_type = WorkType.create!(
      genre: other_genre, name: "別組織分類", display_order: 1, land_flag: true, work_flag: true
    )
    [2015, 2016].each do |term|
      WorkTypeTerm.create!(term: term, work_type: @other_work_type, bg_color: "#123456")
    end
  end

  teardown do
    travel_back
  end

  test "日報の作業分類の選択肢に他組織の作業分類を表示しない" do
    login_as(users(:users1))

    get new_work_path
    assert_response :success
    assert_select "input#work_type_#{@other_work_type.id}", count: 0
    assert_not_includes response.body, @other_category.name

    get work_types_works_path, params: { term: 2015 }, as: :turbo_stream
    assert_response :success
    assert_not_includes response.body, @other_work_type.name

    get work_kinds_works_path, params: { work_type_id: @other_work_type.id }, as: :turbo_stream
    assert_response :not_found
  end

  test "日報の表示に他組織の作業分類を表示しない" do
    login_as(users(:users1))

    get work_path(works(:work_not_fixed))
    assert_response :success
    assert_not_includes response.body, @other_category.name
  end

  test "日報に他組織の作業分類を登録・更新できない" do
    login_as(users(:users1))
    params = {
      worked_at: "2015-05-05", weather_id: :sunny, start_at: "08:00:00", end_at: "17:00:00",
      work_type_id: @other_work_type.id, work_kind_id: work_kinds(:work_kind_taue).id, name: "試験"
    }

    assert_no_difference("Work.count") do
      post works_path, params: { work: params, regist: true }
    end

    work = works(:work_not_fixed)
    patch work_path(work), params: { work: params, regist: true }
    assert_not_equal @other_work_type.id, work.reload.work_type_id
  end

  test "予定の作業分類の選択肢に他組織の作業分類を表示せず登録もできない" do
    login_as(users(:user_user))

    get new_schedule_path
    assert_response :success
    assert_select "input#work_type_#{@other_work_type.id}", count: 0

    params = {
      worked_at: "2015-05-06", work_type_id: @other_work_type.id, start_at: "08:00:00", end_at: "17:00:00",
      calendar_remove_flag: false, farming_flag: true, line_flag: false, minutes_flag: false,
      work_kind_id: work_kinds(:work_kind_taue).id, name: "テスト"
    }
    assert_no_difference("Schedule.count") do
      post schedules_path, params: { schedule: params }
    end
    assert_response :unprocessable_content
  end

  test "作付計画に他組織の作業分類を表示せず登録もできない" do
    user = users(:user_manager)
    login_as(user)
    mode = Plans::LandsController::TERM_MODES[:next]

    get new_plans_land_path(mode: mode)
    assert_response :success
    assert_not_includes response.body, @other_work_type.name

    assert_no_difference("PlanLand.count") do
      post plans_lands_path(mode: mode, user_id: user.id),
           params: { land: { lands(:lands1).id => @other_work_type.id } }
    end
  end

  test "作付計画の作業分類設定に他組織の作業分類を表示せず更新もできない" do
    login_as(users(:user_manager))

    get new_plans_work_type_path
    assert_response :success
    assert_not_includes response.body, @other_work_type.name

    post plans_work_types_path,
         params: { work_types: { @other_work_type.id => { term_flag: false, bg_color: "#000000" } } }
    assert_response :not_found
    assert WorkTypeTerm.exists?(term: 2016, work_type: @other_work_type)
  end

  test "作付計画の前年度取込で他組織の作業分類を取り込まない" do
    login_as(users(:user_manager))
    WorkTypeTerm.where(term: 2016, work_type: @other_work_type).destroy_all

    post import_plans_work_types_path

    assert_not WorkTypeTerm.exists?(term: 2016, work_type: @other_work_type)
  end

  test "タブレットの作付計画に他組織の作業分類を表示せず登録もできない" do
    login_as(users(:user_manager))

    get new_tablets_plans_land_path
    assert_response :success
    assert_select ".work-type[data-work-type-id='#{@other_work_type.id}']", count: 0

    assert_no_difference("PlanLand.count") do
      post tablets_plans_lands_path, params: { land: { lands(:lands1).id => @other_work_type.id } }
    end
  end

  test "タブレットの作業分類設定に他組織の作業分類を表示せず更新もできない" do
    login_as(users(:user_manager))

    get new_tablets_plans_work_type_path
    assert_response :success
    assert_not_includes response.body, @other_work_type.name

    post tablets_plans_work_types_path, params: { work_types: { @other_work_type.id => { term_flag: "0" } } }
    assert WorkTypeTerm.exists?(term: 2016, work_type: @other_work_type)
  end

  test "GAPの作業分類の選択肢に他組織の作業分類を表示しない" do
    login_as(users(:users1))

    [gaps_harvests_path, gaps_health_index_path, gaps_monthly_reports_path].each do |path|
      get path
      assert_response :success
      assert_select "select#work_type_id option[value='#{@other_work_type.id}']", count: 0
    end
  end
end
