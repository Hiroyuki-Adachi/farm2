require "test_helper"

class ScheduleDeliverJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_message)
  end

  test "スケジュールがある場合にLINE通知される" do
    user = users(:user_line_id_already_exists)
    schedule = schedules(:schedule_tomorrow)
    schedule.update!(worked_at: Date.tomorrow)

    called_args = nil
    LineHookService.define_singleton_method(:push_message) do |line_id, message|
      called_args = [line_id, message]
      Net::HTTPOK.new("1.1", "200", "OK")
    end

    perform_enqueued_jobs { ScheduleDeliverJob.perform_now }

    assert called_args, "push_message が呼ばれるべき"
    assert_equal user.line_id, called_args[0]
    assert_includes called_args[1], "明日は以下の予定です。"
  end

  test "スケジュールがない場合にはLINE通知されない" do
    schedule = schedules(:schedule_tomorrow)
    schedule.update!(worked_at: Date.today.since(2.days))

    called = false
    LineHookService.define_singleton_method(:push_message) do |*args|
      called = true
      raise "should not be called"
    end

    perform_enqueued_jobs { ScheduleDeliverJob.perform_now }

    assert_not called, "push_message は呼ばれないはず"
  end

  teardown do
    LineHookService.define_singleton_method(:push_message, @original)
  end
end
