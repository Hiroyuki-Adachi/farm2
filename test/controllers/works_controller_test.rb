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

  test "作業変更(作業者)(表示)" do
    get :edit_workers, params: {id: works(:work_not_fixed)}
    assert_response :success

    get :edit_workers, params: {id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(土地)(表示)" do
    get :edit_lands, params: {id: works(:work_not_fixed)}
    assert_response :success

    get :edit_lands, params: {id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(機械)(表示)" do
    get :edit_machines, params: {id: works(:work_not_fixed)}
    assert_response :success

    get :edit_machines, params: {id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(薬品)(表示)" do
    get :edit_chemicals, params: {id: works(:work_not_fixed)}
    assert_response :success

    get :edit_chemicals, params: {id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(WCS)(表示)" do
    get :edit_whole_crop, params: {id: works(:work_wcs)}
    assert_response :success
  end

  test "作業変更(実行)" do
    get :update, params: {id: works(:work_not_fixed), work: @update, regist: true}
    assert_redirected_to work_path(id: works(:work_not_fixed))
    assert_equal Work.find(works(:work_not_fixed).id).name, @update[:name]

    get :update, params: {id: works(:work_fixed), work: @update, regist: true}
    assert_redirected_to works_path
    assert_equal Work.find(works(:work_fixed).id).name, works(:work_fixed).name

    assert_difference('WorkResult.count') do
      get :update, params: {id: works(:work_not_fixed), results: [worker_id: 1, hours: 1, display_order: 1], regist_workers: true}
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))
    updated_work = Work.find(works(:work_not_fixed).id)
    assert_nil updated_work.printed_by
    assert_nil updated_work.printed_at

    assert_difference('WorkLand.count') do
      get :update, params: {id: works(:work_not_fixed), work_lands: [land_id: 1, display_order: 3], regist_lands: true}
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))

    assert_difference('MachineResult.count') do
      get :update, params: {id: works(:work_not_fixed), machine_hours: { 4 => { WorkResult.last.id => 5 }}, regist_machines: true}
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))

    assert_difference('WorkChemical.count') do
      get :update, params: {
        id: works(:work_not_fixed), chemicals: { 4 => { 1 => {
            aqueous_flag: true, magnification: 10, dilution_amount: 10, quantity: 10
           }}},
        regist_chemicals: true
      }
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))

    assert_not_empty WorkVerification.where(work_id: works(:work_not_fixed), worker_id: User.find(session[:user_id]).worker_id)
  end

  test "作業変更(WCS)(実行)" do
    assert_difference("WholeCropRoll.count", 5) do
      assert_difference("WholeCropLand.count") do
        assert_difference('WorkWholeCrop.count') do
          get :update, params: {
            id: works(:work_wcs),
            whole_crop: {
              work_id: works(:work_wcs),
              wcs_lands: [{
                work_land_id: work_lands(:work_land_wcs1).id,
                display_order: 1,
                rolls: 200,
                wcs_rolls: [
                  {display_order: 1, weight: 290},
                  {display_order: 2, weight: 300},
                  {display_order: 3, weight: 295},
                  {display_order: 4, weight: 298},
                  {display_order: 5, weight: 295}
                ]
              }]
            },
            regist_whole_crop: true
          }
        end
      end
    end
    assert_redirected_to work_path(id: works(:work_wcs))
  end

  test "作業削除" do
    assert_difference('Work.count', -1) do
      delete :destroy, params: {id: works(:work_not_fixed)}
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
