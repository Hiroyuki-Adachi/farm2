require "test_helper"

class WorksDeliverJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_message)
    @user = users(:user_line_id_already_exists)
    @work = works(:work_created_yesterday)
  end

  test "昨日登録した日報がある場合にLINE通知される" do
    @work.update!(created_at: 1.day.ago, created_by: 1)

    called_args = nil
    LineHookService.define_singleton_method(:push_message) do |line_id, message|
      called_args = [line_id, message]
      Net::HTTPOK.new("1.1", "200", "OK")
    end

    perform_enqueued_jobs { WorksDeliverJob.perform_now }

    assert called_args, "push_message が呼ばれるべき"
    assert_equal @user.line_id, called_args[0]
    assert_includes called_args[1], Rails.application.routes.url_helpers.personal_information_url(token: @user.token)
  end

  test "当日登録した日報は未だLINEに通知されない" do
    @work.update!(created_at: Date.today, created_by: 1)

    called = false
    LineHookService.define_singleton_method(:push_message) do |*args|
      called = true
      raise "should not be called"
    end

    perform_enqueued_jobs { WorksDeliverJob.perform_now }

    assert_not called, "push_message は呼ばれないはず"
  end

  test "自分が登録した日報はLINEに通知されない" do
    @work.update!(created_at: 1.day.ago, created_by: @user.worker_id)

    called = false
    LineHookService.define_singleton_method(:push_message) do |*args|
      called = true
      raise "should not be called"
    end

    perform_enqueued_jobs { WorksDeliverJob.perform_now }

    assert_not called, "push_message は呼ばれないはず"
  end

  test "自分が参加していない作業の日報はLINEに通知されない" do
    @work.update!(created_at: 1.day.ago, created_by: 1)
    @work.work_results.where(worker_id: @user.worker_id).destroy_all

    called = false
    LineHookService.define_singleton_method(:push_message) do |*args|
      called = true
      raise "should not be called"
    end

    perform_enqueued_jobs { WorksDeliverJob.perform_now }

    assert_not called, "push_message は呼ばれないはず"
  end

  teardown do
    LineHookService.define_singleton_method(:push_message, @original)
  end
end
