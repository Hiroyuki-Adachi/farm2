require "test_helper"

class DailyWeatherCheckJobTest < ActiveJob::TestCase
  setup do
    Rails.application.credentials.stubs(:dig).with(:line, :secretariant_id).returns("fake-line-id")
    @line_id = "fake-line-id"
  end

  test "通知されない(最新日付が10日以内)" do
    travel_to Time.zone.local(2026, 3, 14, 12, 0, 0) do
      DailyWeather.stubs(:maximum).with(:target_date).returns(Date.new(2026, 3, 4))

      LineHookService.expects(:push_message).never
      perform_enqueued_jobs { DailyWeatherCheckJob.perform_now }
    end
  end

  test "通知される(最新日付が11日以上前)" do
    travel_to Time.zone.local(2026, 3, 14, 12, 0, 0) do
      DailyWeather.stubs(:maximum).with(:target_date).returns(Date.new(2026, 3, 3))

      LineHookService.expects(:push_message).with(
        @line_id,
        includes("日次気象データが 10 日以上更新されていません。"),
        has_key(:retry_key)
      )
      perform_enqueued_jobs { DailyWeatherCheckJob.perform_now }
    end
  end

  test "通知される(データ未登録)" do
    DailyWeather.stubs(:maximum).with(:target_date).returns(nil)

    LineHookService.expects(:push_message).with(
      @line_id,
      includes("最新登録日: 未登録"),
      has_key(:retry_key)
    )
    perform_enqueued_jobs { DailyWeatherCheckJob.perform_now }
  end

  test "LINE通知先が未設定なら通知しない" do
    Rails.application.credentials.stubs(:dig).with(:line, :secretariant_id).returns(nil)
    DailyWeather.stubs(:maximum).with(:target_date).returns(Date.new(2026, 3, 1))

    LineHookService.expects(:push_message).never
    perform_enqueued_jobs { DailyWeatherCheckJob.perform_now }
  end
end
