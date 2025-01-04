require "test_helper"

class Works::WorkersControllerTest < ActionController::TestCase
  HOURS = 1.5
  DISPLAY_ORDER = 1

  setup do
    setup_ip
    @user = users(:users1)
  end

  test "作業変更(作業者)(表示)" do
    get :new, params: {work_id: works(:work_not_fixed)}
    assert_response :success

    get :new, params: {work_id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(作業者)(変更)" do
    worker_id = workers(:worker2).id
    assert_difference('WorkVerification.count', 1) do
      assert_no_difference('WorkResult.count') do
        post :create, params: {work_id: works(:work_not_fixed), results: [
          worker_id: worker_id, hours: HOURS, display_order: DISPLAY_ORDER
        ], regist_workers: true}
      end
    end
    assert_redirected_to new_work_health_path(work_id: works(:work_not_fixed))
    updated_work = Work.find(works(:work_not_fixed).id)
    updated_work_worker = WorkResult.find_by(work_id: works(:work_not_fixed).id, worker_id: worker_id)

    # 印刷情報がクリアされていること
    assert_nil updated_work.printed_by
    assert_nil updated_work.printed_at

    # 作業者の変更が反映されていること
    assert_not_nil updated_work_worker
    assert_equal HOURS, updated_work_worker.hours
    assert_equal DISPLAY_ORDER, updated_work_worker.display_order
  end
end
