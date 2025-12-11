require "test_helper"

class ScheduleDeliverJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_message)
    @user = users(:user_line_id_already_exists)
  end

  test "スケジュールがある場合にLINE通知される(午前)" do
    schedule = schedules(:schedule_today)

    called_args = nil
    LineHookService.stubs(:push_message)
      .with do |line_id, message, kwargs|
        called_args = [line_id, message]
        # retry_key が付いてきてもOKにする
        kwargs[:retry_key].is_a?(String) || kwargs[:retry_key].nil?
      end
      .returns(Net::HTTPOK.new("1.1", "200", "OK"))

    travel_to schedule.worked_at.change(hour: 8) do
      ScheduleDeliverJob.perform_now(:morning)
    end

    assert called_args, "push_message が呼ばれるべき"
    assert_equal @user.line_id, called_args[0]
    assert_includes called_args[1], I18n.t('line_deliver_schedule.morning')
  end

  test "スケジュールがある場合にLINE通知される(午後)" do
    schedule = schedules(:schedule_tomorrow)

    called_args = nil
    LineHookService.stubs(:push_message)
      .with do |line_id, message, kwargs|
        called_args = [line_id, message]
        # retry_key が付いてきてもOKにする
        kwargs[:retry_key].is_a?(String) || kwargs[:retry_key].nil?
      end
      .returns(Net::HTTPOK.new("1.1", "200", "OK"))

    travel_to (schedule.worked_at - 1.day).change(hour: 15) do
      ScheduleDeliverJob.perform_now(:afternoon)
    end

    assert called_args, "push_message が呼ばれるべき"
    assert_equal @user.line_id, called_args[0]
    assert_includes called_args[1], I18n.t('line_deliver_schedule.afternoon')
  end

  test "スケジュールがない場合にはLINE通知されない" do
    ScheduleWorker.where(worker: @user.worker).destroy_all

    LineHookService.expects(:push_message).never

    perform_enqueued_jobs { ScheduleDeliverJob.perform_now(:morning) }
  end
end
