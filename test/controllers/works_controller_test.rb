require 'test_helper'

class WorksControllerTest < ActionController::TestCase
  setup do
    @request = ActionController::TestRequest.new
    @request.instance_eval do
      def remote_ip
        "127.0.0.1"
      end
    end
    @update = { 
      worked_at: "2015-05-05", weather_id: 1, start_at: "08:00:00", end_at: "17:00:00",
      work_type_id: work_types(:work_type_koshi).id, work_kind_id: work_kinds(:work_kind_taue).id,
      name: "試験", remarks: "備考だよーーー"
    }
  end

  test "作業一覧" do
    get :index
    assert_response :success
  end

  test "作業登録(表示)" do
    get :new
    assert_response :success
  end

  test "作業登録(実行)" do
    assert_difference('Work.count') do
      post :create, work: @update, regist: true
    end

    assert_no_difference('Work.count') do
      post :create, work: @update, cancel: true
    end
    assert_redirected_to root_path
  end

  test "作業照会" do
    get :show, id: works(:work_fixed)
    assert_response :success

    get :show, id: works(:work_not_fixed)
    assert_response :success
  end

  test "作業変更(表示)" do
    get :edit, id: works(:work_not_fixed)
    assert_response :success

    get :edit, id: works(:work_fixed)
    assert_redirected_to works_path
  end

  test "作業変更(作業者)(表示)" do
    get :edit_workers, id: works(:work_not_fixed)
    assert_response :success

    get :edit_workers, id: works(:work_fixed)
    assert_redirected_to works_path
  end

  test "作業変更(土地)(表示)" do
    get :edit_lands, id: works(:work_not_fixed)
    assert_response :success

    get :edit_lands, id: works(:work_fixed)
    assert_redirected_to works_path
  end

  test "作業変更(機械)(表示)" do
    get :edit_machines, id: works(:work_not_fixed)
    assert_response :success

    get :edit_machines, id: works(:work_fixed)
    assert_redirected_to works_path
  end

  test "作業変更(薬品)(表示)" do
    get :edit_chemicals, id: works(:work_not_fixed)
    assert_response :success

    get :edit_chemicals, id: works(:work_fixed)
    assert_redirected_to works_path
  end

  test "作業変更(実行)" do
    get :update, id: works(:work_not_fixed), work: @update, cancel: true
    assert_redirected_to work_path(id: works(:work_not_fixed))
    assert_equal Work.find(works(:work_not_fixed).id).name, works(:work_not_fixed).name

    get :update, id: works(:work_not_fixed), work: @update, regist: true
    assert_redirected_to work_path(id: works(:work_not_fixed))
    assert_equal Work.find(works(:work_not_fixed).id).name, @update[:name]

    get :update, id: works(:work_fixed), work: @update, regist: true
    assert_redirected_to works_path
    assert_equal Work.find(works(:work_fixed).id).name, works(:work_fixed).name

    assert_difference('WorkResult.count') do
      get :update, id: works(:work_not_fixed), results: [{worker_id: 1, hours: 1, display_order: 1}], regist_workers: true
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))

    assert_difference('WorkLand.count') do
      get :update, id: works(:work_not_fixed), work_lands: [{land_id: 1, display_order: 3}], regist_lands: true
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))
  end

  test "作業削除" do
    assert_difference('Work.count', -1) do
      delete :destroy, id: works(:work_not_fixed)
    end
    assert_redirected_to works_path

    assert_no_difference('Work.count') do
      delete :destroy, id: works(:work_fixed)
    end
    assert_redirected_to works_path
  end
end
