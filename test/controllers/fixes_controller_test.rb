require 'test_helper'

class FixesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @fix = fixes(:fix1)
    @no_fix_works = [works(:work_no_fix1).id, works(:work_no_fix2).id]
  end

  test "確定一覧" do
    get :index
    assert_response :success
  end

  test "確定一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "確定照会" do
    get :show, fixed_at: @fix
    assert_response :success
  end

  test "新規確定(表示)" do
    get :new
    assert_response :success
  end

  test "新規確定(実行)" do
    fixed_at = '2015-03-31'
    assert_difference('Fix.count') do
      post :create, fixed_at: fixed_at, fixed_works: @no_fix_works
    end
    assert_equal fixed_at, Work.find(works(:work_no_fix1).id).fixed_at.strftime('%Y-%m-%d')
    assert_equal fixed_at, Work.find(works(:work_no_fix2).id).fixed_at.strftime('%Y-%m-%d')
    assert_equal users(:users1).worker_id, Fix.where(fixed_at: fixed_at, term: 2015).first.fixed_by
    assert_redirected_to fixes_path
  end

  test "確定取消" do
    assert_difference('Fix.count', -1) do
      delete :destroy, fixed_at: @fix
    end
    assert_redirected_to fixes_path
  end
end
