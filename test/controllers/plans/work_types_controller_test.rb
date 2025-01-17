require 'test_helper'

class Plans::WorkTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_manager)
    login_as(@user)
    @work_type = work_types(:work_types17)
    travel_to(Date.new(2015, 1, 1))
  end

  teardown do
    travel_back
  end

  test "作付予定(表示)" do
    get new_plans_work_type_path
    assert_response :success
  end

  test "作付予定(表示)(管理者以外)" do
    login_as(users(:user_checker))
    get new_plans_work_type_path
    assert_response :error
  end

  test "作付予定(表示)(日付不正)" do
    travel_to(Date.new(2016, 1, 1)) do
      get new_plans_work_type_path
      assert_response :error
    end
  end

  test "作付予定(作成)(追加)" do
    # 追加パターン
    work_type = {
      @work_type.id => {term_flag: true, bg_color: "ffffff"}
    }
    assert_difference('WorkTypeTerm.count') do
      post plans_work_types_path, params: {work_types: work_type}
    end
    assert_redirected_to new_plans_work_type_path

    created_work_type = WorkTypeTerm.last
    assert_equal @work_type.id, created_work_type.work_type_id
    assert_equal work_type[@work_type.id][:bg_color], created_work_type.bg_color
    assert_equal @user.term + 1, created_work_type.term

    # 追加後の更新パターン
    work_type = {
      @work_type.id => {term_flag: true, bg_color: "000000"}
    }
    assert_no_difference('WorkTypeTerm.count') do
      post plans_work_types_path, params: {work_types: work_type}
    end
    assert_redirected_to new_plans_work_type_path

    created_work_type.reload
    assert_equal work_type[@work_type.id][:bg_color], created_work_type.bg_color
  end
end
