require 'test_helper'

class Plans::LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_manager)
    login_as(@user)
    @mode = Plans::LandsController::TERM_MODES[:next]
    travel_to(Date.new(2015, 1, 1))
  end

  teardown do
    travel_back
  end

  test "作付計画は未作成の次期だけを組織内に先行作成する" do
    System.where(organization_id: @user.organization_id, term: 2016..).destroy_all
    other_systems = System.where.not(organization_id: @user.organization_id).pluck(:id, :updated_at)

    assert_difference("System.count", 1) do
      2.times { get new_plans_land_path(mode: @mode) }
    end

    assert_response :success
    system = System.find_by!(organization_id: @user.organization_id, term: 2016)
    assert_equal Date.new(2016, 1, 1), system.start_date
    assert_equal Date.new(2016, 12, 31), system.end_date
    assert_equal other_systems, System.where.not(organization_id: @user.organization_id).pluck(:id, :updated_at)
  end

  test "作付計画は明示設定済みの短い次期を上書きしない" do
    System.where(organization_id: @user.organization_id, term: 2017..).destroy_all
    system = systems(:s2016)
    system.update!(term_name: "短期", end_date: Date.new(2016, 3, 31))
    original_attributes = system.attributes

    get new_plans_land_path(mode: @mode)

    assert_response :success
    assert_equal original_attributes, system.reload.attributes
  end

  test "管理者以外の作付計画アクセスは次期を作成しない" do
    System.where(organization_id: @user.organization_id, term: 2016..).destroy_all
    login_as(users(:user_checker))

    assert_no_difference("System.count") { get new_plans_land_path(mode: @mode) }

    assert_response :service_unavailable
  end

  test "作付計画(表示)" do
    get new_plans_land_path(mode: @mode)
    assert_response :success
    assert_select "select#user_id option[value='#{@user.id}'][selected]", text: @user.worker.name
    assert_select "select#user_id option[value='#{users(:users1).id}']", text: users(:users1).worker.name
    assert_select "select#user_id option[value='#{users(:user_checker).id}']", count: 0
    assert_select "select#user_id option[value='#{users(:user_admin_org2).id}']", count: 0
    assert_select "input[type='submit'][value='登録']:not([disabled])"
  end

  test "作付計画の当期見出しに年度名をそのまま表示する" do
    systems(:s2015).update!(term_name: "第15期")
    systems(:s2016).update!(term_name: "第16期")

    get new_plans_land_path(mode: Plans::LandsController::TERM_MODES[:current])

    assert_response :success
    assert_select ".h1", text: "作付計画(第15期)"
  end

  test "作付計画の次期見出しに年度名をそのまま表示する" do
    systems(:s2015).update!(term_name: "第15期")
    systems(:s2016).update!(term_name: "第16期")

    get new_plans_land_path(mode: Plans::LandsController::TERM_MODES[:next])

    assert_response :success
    assert_select ".h1", text: "作付計画(第16期)"
  end

  test "作付計画(他の管理者を表示)" do
    target_user = users(:users1)
    term = @user.organization.get_term(Time.zone.today.next_year)
    plan_land = PlanLand.create!(
      user: target_user, term: term, land: lands(:lands1), work_type: work_types(:work_types2)
    )

    get new_plans_land_path(mode: @mode, user_id: target_user.id)

    assert_response :success
    assert_select "select#user_id option[value='#{target_user.id}'][selected]", text: target_user.worker.name
    assert_select "input#land_#{plan_land.land_id}[value='#{plan_land.work_type_id}']"
    assert_select "input[type='submit'][value='登録'][disabled]"
    assert_select "button[disabled]", text: "初期化"
    assert_select "a[href='#{plans_lands_path(mode: @mode, user_id: target_user.id)}']", text: "Z-GIS出力"
  end

  test "作付計画(他の管理者のZ-GIS出力)" do
    target_user = users(:users1)
    term = @user.organization.get_term(Time.zone.today.next_year)
    PlanLand.create!(
      user: target_user, term: term, land: lands(:lands1), work_type: work_types(:work_types2)
    )

    Tempfile.create(["zgis", ".zip"]) do |file|
      file.write("zip")
      file.close
      ZgisExcelService.expects(:call).with do |plan_lands, _work_types, plan_term|
        plan_lands.pluck(:user_id).uniq == [target_user.id] && plan_term == term
      end.returns(file.path)

      get plans_lands_path(mode: @mode, user_id: target_user.id)

      assert_response :success
      assert_equal "application/zip", response.media_type
    end
  end

  test "作付計画(選択対象外のユーザーを表示できない)" do
    get new_plans_land_path(mode: @mode, user_id: users(:user_checker).id)
    assert_response :error
  end

  test "作付計画(他組織のユーザーを表示できない)" do
    get new_plans_land_path(mode: @mode, user_id: users(:user_admin_org2).id)
    assert_response :error
  end

  test "作付計画(モード不正)" do
    get new_plans_land_path(mode: 999)
    assert_response :error
  end

  test "作付計画(表示)(日付不正)" do
    travel_to(Date.new(2016, 1, 1)) do
      get new_plans_land_path(mode: @mode)
      assert_response :error
    end
  end

  test "作付計画(表示)(管理者以外)" do
    login_as(users(:user_checker))
    get new_plans_land_path(mode: @mode)
    assert_response :error
  end

  test "作付計画(登録)" do
    land = lands(:lands2)
    work_type = work_types(:work_types2)
    PlanLand.delete_all
    assert_difference('PlanLand.count') do
      post plans_lands_path(mode: @mode), params: { land: { land.id => work_type.id } }
    end
    assert_redirected_to new_plans_land_path(mode: @mode, user_id: @user.id)

    term = @user.organization.get_term(Time.zone.today.next_year)

    created_plan_land = PlanLand.find_by(term: term, land_id: land.id, user_id: @user.id)
    assert_not_nil created_plan_land
    assert_equal work_type.id, created_plan_land.work_type_id
  end

  test "作付計画(他の管理者の計画を登録できない)" do
    target_user = users(:users1)
    land = lands(:lands2)
    work_type = work_types(:work_types2)

    assert_no_difference('PlanLand.count') do
      post plans_lands_path(mode: @mode, user_id: target_user.id), params: { land: { land.id => work_type.id } }
    end
    assert_response :error
  end

  test "作付計画(初期化)" do
    delete plans_land_path(mode: @mode, id: 0)
    assert_redirected_to new_plans_land_path(mode: @mode, user_id: @user.id)
  end

  test "作付計画(他の管理者の計画を初期化できない)" do
    target_user = users(:users1)
    term = @user.organization.get_term(Time.zone.today.next_year)
    plan_land = PlanLand.create!(
      user: target_user, term: term, land: lands(:lands1), work_type: work_types(:work_types2)
    )

    assert_no_difference('PlanLand.count') do
      delete plans_land_path(mode: @mode, id: 0, user_id: target_user.id)
    end
    assert_response :error
    assert PlanLand.exists?(
      user_id: target_user.id, term: term, land_id: plan_land.land_id, work_type_id: plan_land.work_type_id
    )
  end

  test "作付計画の初期化で他組織の土地を登録しない" do
    other_land = lands(:land_other_org)
    other_land.update!(region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))")
    LandCost.create!(land: other_land, work_type: work_types(:work_type_koshi), activated_on: Date.new(1900, 1, 1))

    delete plans_land_path(mode: @mode, id: 0)

    term = @user.organization.get_term(Time.zone.today.next_year)
    assert_nil PlanLand.find_by(term: term, land_id: other_land.id, user_id: @user.id)
  end
end
