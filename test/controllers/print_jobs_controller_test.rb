require "test_helper"

class PrintJobsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @template = print_templates(:print_template_daily)
    @job = PrintJob.create!(organization_id: 1, print_template: @template, requested_by: users(:users1), copies: 2)
  end

  test "印刷指示一覧" do
    @job.update!(status: :failed, error_message: "用紙切れ")
    get print_jobs_path
    assert_response :success
    assert_select "tr#print_job_#{@job.id}" do
      assert_select "td", text: @template.title
      assert_select "td", text: "用紙切れ"
      assert_select ".badge", text: "失敗"
    end
    assert_select "tr#print_job_#{print_jobs(:print_job_submitted).id}"
  end

  test "印刷指示一覧に他組織の印刷指示は表示しない" do
    other = PrintJob.create!(organization_id: 2, print_template: print_templates(:print_template_other_org),
                             requested_by: users(:user_admin_org2), copies: 1)
    get print_jobs_path
    assert_response :success
    assert_select "tr#print_job_#{other.id}", count: 0
  end

  test "待機中の印刷指示だけ取消ボタンを表示する" do
    get print_jobs_path
    assert_select "tr#print_job_#{@job.id} form[action='#{cancel_print_job_path(@job)}']"
    assert_select "tr#print_job_#{print_jobs(:print_job_submitted).id} form", count: 0
  end

  test "待機中の印刷指示を取り消す" do
    patch cancel_print_job_path(@job)
    assert_redirected_to print_jobs_path
    assert @job.reload.status_canceled?
  end

  test "待機中でない印刷指示は取り消せない" do
    @job.update!(status: :claimed)
    patch cancel_print_job_path(@job)
    assert_redirected_to print_jobs_path
    assert_equal "待機中ではないため、取り消せません。", flash[:alert]
    assert @job.reload.status_claimed?
  end

  test "他組織の印刷指示は取り消せない" do
    other = PrintJob.create!(organization_id: 2, print_template: print_templates(:print_template_other_org),
                             requested_by: users(:user_admin_org2), copies: 1)
    patch cancel_print_job_path(other)
    assert_response :not_found
    assert other.reload.status_waiting?
  end

  test "管理者以外は印刷指示一覧を使えない" do
    login_as(users(:user_manager))
    get print_jobs_path
    assert_response :service_unavailable
    patch cancel_print_job_path(@job)
    assert_response :service_unavailable
    assert @job.reload.status_waiting?
  end
end
