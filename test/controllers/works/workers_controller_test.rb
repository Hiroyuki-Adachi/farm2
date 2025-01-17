require "test_helper"

class Works::WorkersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @work = works(:work_not_fixed)
    login_as(@user)
  end

  test "作業変更(作業者)(表示)" do
    get new_work_worker_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(作業者)(表示)(確定済)" do
    get new_work_worker_path(work_id:works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(作業者)(変更)" do
    worker_id = workers(:worker2).id
    results = [
      {worker_id: worker_id, hours: 1.5, display_order: 1}
    ]
    assert_difference('WorkVerification.count') do
      assert_no_difference('WorkResult.count') do
        post work_workers_path(work_id: @work), params: {
          results: results,
          regist_workers: true
        }
      end
    end
    assert_redirected_to new_work_health_path(work_id: @work)

    # 印刷情報がクリアされていること
    @work.reload
    assert_nil @work.printed_by
    assert_nil @work.printed_at

    # 作業者の変更が反映されていること
    updated_work_results = WorkResult.where(work_id: @work.id).order(:display_order)
    assert_not_empty updated_work_results
    assert_equal results.size, updated_work_results.count
    updated_work_results.each_with_index do |updated_work_result, index|
      assert_equal @work.id, updated_work_result.work_id
      assert_equal results[index][:worker_id], updated_work_result.worker_id
      assert_equal results[index][:hours], updated_work_result.hours
      assert_equal results[index][:display_order], updated_work_result.display_order
    end

    # 検証情報が登録されていること
    created_work_verification = WorkVerification.last
    assert_equal @work.id, created_work_verification.work_id
    assert_equal @user.worker.id, created_work_verification.worker_id
  end
end
