require 'test_helper'

class Plans::WorkTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
    @work_type = work_types(:work_types17)
    travel_to(Date.new(2015, 1, 1))
  end

  teardown do
    travel_back
  end

  test "作付予定(表示)" do
    get :new
    assert_response :success
  end

  test "作付予定(表示)(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :new
    assert_response :error
  end

  test "作付予定(表示)(日付不正)" do
    travel_to(Date.new(2016, 1, 1)) do
      get :new
      assert_response :error
    end
  end

  test "作付予定(作成)(追加)" do
    # 追加パターン
    assert_difference 'WorkTypeTerm.count', 1 do
      post :create, params: {work_types: {
        @work_type.id => {term_flag: true, bg_color: "ffffff"}
      }}
    end
    assert_redirected_to new_plans_work_type_path

    # 追加後の更新パターン
    assert_difference 'WorkTypeTerm.count', 0 do
      post :create, params: {work_types: {
        @work_type.id => {term_flag: true, bg_color: "000000"}
      }}
    end
    assert_redirected_to new_plans_work_type_path
  end
end
