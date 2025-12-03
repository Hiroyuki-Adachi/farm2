require "test_helper"

class WorksDeliverJobTest < ActiveJob::TestCase
  setup do
    @user = users(:user_line_id_already_exists)
    @work = works(:work_created_yesterday)
  end

  test "昨日登録した日報がある場合にLINE通知される" do
    @work.update!(created_at: 1.day.ago, created_by: 1)

    called_args = nil

    LineHookService.stubs(:push_message)
      .with do |line_id, message, kwargs|
        called_args = [line_id, message]
        # retry_key が付いてきてもOKにする
        kwargs[:retry_key].is_a?(String) || kwargs[:retry_key].nil?
      end
      .returns(Net::HTTPOK.new("1.1", "200", "OK"))

    perform_enqueued_jobs { WorksDeliverJob.perform_now }

    assert called_args, "push_message が呼ばれるべき"
    assert_equal @user.line_id, called_args[0]
    assert_includes called_args[1], Rails.application.routes.url_helpers.personal_information_url(token: @user.token)
  end

  test "当日登録した日報は未だLINEに通知されない" do
    @work.update!(created_at: Time.zone.today, created_by: 1)

    LineHookService.expects(:push_message).never

    perform_enqueued_jobs { WorksDeliverJob.perform_now }
  end

  test "自分が登録した日報はLINEに通知されない" do
    @work.update!(created_at: 1.day.ago, created_by: @user.worker_id)

    LineHookService.expects(:push_message).never

    perform_enqueued_jobs { WorksDeliverJob.perform_now }
  end

  test "自分が参加していない作業の日報はLINEに通知されない" do
    @work.update!(created_at: 1.day.ago, created_by: 1)
    @work.work_results.where(worker_id: @user.worker_id).destroy_all

    LineHookService.expects(:push_message).never

    perform_enqueued_jobs { WorksDeliverJob.perform_now }
  end
end
