require 'test_helper'

class WorksControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @update = {
      worked_at: "2015-05-05", weather_id: 1, start_at: "08:00:00", end_at: "17:00:00",
      work_type_id: work_types(:work_type_koshi).id, work_kind_id: work_kinds(:work_kind_taue).id,
      name: "試験", remarks: "備考だよーーー"
    }
    request.headers['HTTP_REFERER'] = 'http://127.0.0.1/'
  end

  test "作業一覧" do
    get :index
    assert_response :success
  end

  test "作業登録(表示)" do
    get :new
    assert_response :success
  end

  test "作業登録(閲覧者)" do
    session[:user_id] = users(:user_visitor).id
    get :new
    assert_response :error
  end

  test "作業登録(実行)" do
    assert_difference('Work.count') do
      post :create, params: {work: @update, regist: true}
    end

    work = Work.where(name: "試験").first
    user = User.find(session[:user_id])
    assert_not_nil work
    assert_equal work.created_by, user.worker.id
  end

  test "作業照会" do
    get :show, params: {id: works(:work_fixed)}
    assert_response :success

    get :show, params: {id: works(:work_not_fixed)}
    assert_response :success
  end

  test "作業照会(薬品)" do
    get :show, params: {id: works(:work_chemical_test).id}
    assert_response :success
  end

  test "作業変更(表示)" do
    get :edit, params: {id: works(:work_not_fixed)}
    assert_response :success

    get :edit, params: {id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(過去年度)" do
    get :edit, params: {id: works(:works_past)}
    assert_response :error
  end

  test "作業変更(実行)" do
    get :update, params: {id: works(:work_not_fixed), work: @update, regist: true}
    assert_redirected_to work_path(id: works(:work_not_fixed))
    assert_equal Work.find(works(:work_not_fixed).id).name, @update[:name]

    get :update, params: {id: works(:work_fixed), work: @update, regist: true}
    assert_redirected_to works_path
    assert_equal Work.find(works(:work_fixed).id).name, works(:work_fixed).name

    assert_not_empty WorkVerification.where(work_id: works(:work_not_fixed), worker_id: User.find(session[:user_id]).worker_id)
  end

  test "作業削除" do
    assert_difference('WorkWorkType.count', -1) do
      assert_difference('WorkResult.count', -1) do
        assert_difference('WorkLand.count', -2) do
          assert_difference('Work.count', -1) do
            delete :destroy, params: {id: works(:work_not_fixed)}
          end
        end
      end
    end
    assert_redirected_to works_path

    assert_no_difference('Work.count') do
      delete :destroy, params: {id: works(:work_fixed)}
    end
    assert_redirected_to works_path
  end

  test "作業削除(過去年度)" do
    assert_no_difference('Work.count') do
      delete :destroy, params: {id: works(:works_past)}
    end
    assert_response :error
  end
end
