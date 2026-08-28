require "test_helper"

class Tablets::Plans::WorkTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_manager)
    @work_type = work_types(:work_types2)
    login_as(@user)
    travel_to(Date.new(2015, 1, 1))
  end

  teardown do
    travel_back
  end

  test "作付予定を表示する" do
    get new_tablets_plans_work_type_path

    assert_response :success
    assert_select "h1", count: 0
    assert_select "input[type=color]", count: 0
    assert_select "input.form-check-input[role=switch]"
    assert_select "form[action='#{tablets_plans_work_types_path}']"
  end

  test "管理者以外は作付予定を表示できない" do
    login_as(users(:user_checker))

    get new_tablets_plans_work_type_path

    assert_response :error
  end

  test "作付予定を登録する" do
    assert_difference("WorkTypeTerm.count", 1) do
      post tablets_plans_work_types_path, params: {
        work_types: { @work_type.id => { term_flag: "1" } }
      }
    end

    assert_redirected_to new_tablets_plans_work_type_path
    assert WorkTypeTerm.exists?(term: @user.term + 1, work_type_id: @work_type.id)
  end

  test "作付予定を解除する" do
    work_type_term = WorkTypeTerm.create!(
      term: @user.term + 1,
      work_type: @work_type,
      bg_color: "#abcdef"
    )

    assert_difference("WorkTypeTerm.count", -1) do
      post tablets_plans_work_types_path, params: {
        work_types: { @work_type.id => { term_flag: "0" } }
      }
    end

    assert_redirected_to new_tablets_plans_work_type_path
    assert_not WorkTypeTerm.exists?(work_type_term.id)
  end

  test "登録済みの配色を変更しない" do
    work_type_term = WorkTypeTerm.create!(
      term: @user.term + 1,
      work_type: @work_type,
      bg_color: "#abcdef"
    )

    assert_no_difference("WorkTypeTerm.count") do
      post tablets_plans_work_types_path, params: {
        work_types: { @work_type.id => { term_flag: "1" } }
      }
    end

    assert_equal "#abcdef", work_type_term.reload.bg_color
  end
end
