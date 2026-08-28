require "test_helper"

class Tablets::Plans::LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_manager)
    @work_type = work_types(:work_types2)
    @land = lands(:lands1)
    login_as(@user)
    travel_to(Date.new(2015, 1, 1))
    WorkTypeTerm.find_or_create_by!(term: @user.term + 1, work_type: @work_type) do |term|
      term.bg_color = "#abcdef"
    end
  end

  teardown do
    travel_back
  end

  test "来年度の自分の作付計画を表示する" do
    plan_land = PlanLand.create!(
      user: @user,
      term: @user.term + 1,
      land: @land,
      work_type: @work_type
    )

    get new_tablets_plans_land_path

    assert_response :success
    assert_select "h1", count: 0
    assert_select "select#user_id", count: 0
    assert_select "a", text: "今年度", count: 0
    assert_select "a", text: "来年度", count: 0
    assert_select "button", text: "印刷", count: 0
    assert_select "a", text: "Z-GIS出力", count: 0
    assert_select "[data-page-loader-modules-value='pages/tablets/plan-lands']"
    assert_select "button#toggle_land_labels[aria-pressed='true']", text: "地番・面積を隠す"
    assert_select "form[action='#{clear_tablets_plans_lands_path}']"
    selector = "input#land_#{@land.id}[value='#{plan_land.work_type_id}']" \
               "[data-place='#{@land.place}'][data-area='#{@land.area}'][data-center]"
    assert_select selector
    assert_select ".work-type[data-work-type-id='#{@work_type.id}']"
  end

  test "他組織の土地を表示しない" do
    other_land = lands(:land_other_org)
    other_land.update!(
      region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))"
    )

    get new_tablets_plans_land_path

    assert_response :success
    assert_select "input#land_#{other_land.id}", count: 0
  end

  test "管理者以外は作付計画を表示できない" do
    login_as(users(:user_checker))

    get new_tablets_plans_land_path

    assert_response :error
  end

  test "来年度の自分の作付計画を登録する" do
    PlanLand.delete_all

    assert_difference("PlanLand.count", 1) do
      post tablets_plans_lands_path,
           params: {
             user_id: users(:users1).id,
             land: { @land.id => @work_type.id }
           }
    end

    assert_redirected_to new_tablets_plans_land_path
    assert PlanLand.exists?(
      user: @user,
      term: @user.term + 1,
      land: @land,
      work_type: @work_type
    )
    assert_not PlanLand.exists?(user: users(:users1), term: @user.term + 1, land: @land)
  end

  test "来年度の作付対象外の作業分類を登録できない" do
    existing = PlanLand.create!(
      user: @user,
      term: @user.term + 1,
      land: @land,
      work_type: @work_type
    )

    assert_no_difference("PlanLand.count") do
      post tablets_plans_lands_path, params: {
        land: { @land.id => work_types(:work_types17).id }
      }
    end

    assert_response :error
    assert PlanLand.exists?(
      user: existing.user,
      term: existing.term,
      land: existing.land,
      work_type: existing.work_type
    )
  end

  test "画面に表示されない同一組織の土地を登録できない" do
    hidden_land = lands(:lands2)
    existing = PlanLand.create!(
      user: @user,
      term: @user.term + 1,
      land: @land,
      work_type: @work_type
    )

    assert_no_difference("PlanLand.count") do
      post tablets_plans_lands_path, params: {
        land: {
          @land.id => @work_type.id,
          hidden_land.id => @work_type.id
        }
      }
    end

    assert_response :error
    assert PlanLand.exists?(
      user: existing.user,
      term: existing.term,
      land: existing.land,
      work_type: existing.work_type
    )
    assert_not PlanLand.exists?(user: @user, term: @user.term + 1, land: hidden_land)
  end

  test "管理者以外は作付計画を登録できない" do
    login_as(users(:user_checker))

    assert_no_difference("PlanLand.count") do
      post tablets_plans_lands_path, params: { land: { @land.id => @work_type.id } }
    end
    assert_response :error
  end

  test "作付計画を自分の来年度の土地原価で初期化する" do
    delete clear_tablets_plans_lands_path

    assert_redirected_to new_tablets_plans_land_path
  end
end
