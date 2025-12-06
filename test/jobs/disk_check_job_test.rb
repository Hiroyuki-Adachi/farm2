require "test_helper"

class DiskCheckJobTest < ActiveJob::TestCase
  setup do
    Rails.application.credentials.stubs(:dig).with(:line, :secretariant_id).returns("fake-line-id")
    @line_id = 'fake-line-id'
  end

  def stub_df(fake_df)
    DiskCheckJob.any_instance.stubs(:`).with("df / -h | tail -1").returns(fake_df)
  end

  test "通知されない(空き容量が41%以上)(月曜日)" do
    stub_df('/dev/sda1   40G   10G   30G  25% /')

    travel_to Time.zone.local(2023, 10, 2, 12, 0, 0) do
      LineHookService.expects(:push_message).never
      perform_enqueued_jobs { DiskCheckJob.perform_now }
    end
  end

  test "通知される(空き容量が41%以上)(日曜日)" do
    stub_df('/dev/sda1   40G   10G   30G  25% /')

    travel_to Time.zone.local(2023, 10, 1, 12, 0, 0) do
      LineHookService.expects(:push_message).with(@line_id, includes('🟦'), has_key(:retry_key))
      perform_enqueued_jobs { DiskCheckJob.perform_now }
    end
  end

  test "通知される(空き容量が20%)" do
    stub_df('/dev/sda1   40G   32G   8G  80% /')

    LineHookService.expects(:push_message).with(@line_id, includes('🟧'), has_key(:retry_key))
    perform_enqueued_jobs { DiskCheckJob.perform_now }
  end

  test "通知される(空き容量が5%)(全曜日)" do
    stub_df('/dev/sda1   40G   38G   2G  95% /')

    7.times do |i|
      travel_to Time.zone.local(2023, 10, 1 + i, 12, 0, 0) do
        LineHookService.expects(:push_message).with(@line_id, includes('🟥'), has_key(:retry_key))
        perform_enqueued_jobs { DiskCheckJob.perform_now }
      end
    end
  end
end
