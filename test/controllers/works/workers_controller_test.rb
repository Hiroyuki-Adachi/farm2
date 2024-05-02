require "test_helper"

class Works::WorkersControllerTest < ActionController::TestCase
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
    assert_difference('WorkVerification.count', 1) do
      assert_no_difference('WorkResult.count') do
        post :create, params: {work_id: works(:work_not_fixed), results: [worker_id: 1, hours: 1, display_order: 1], regist_workers: true}
      end
    end
    assert_redirected_to new_work_health_path(work_id: works(:work_not_fixed))
    updated_work = Work.find(works(:work_not_fixed).id)
    assert_nil updated_work.printed_by
    assert_nil updated_work.printed_at
  end
end
