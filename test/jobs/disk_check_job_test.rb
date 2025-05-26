require "test_helper"

class DiskCheckJobTest < ActiveJob::TestCase
  LINE_ID = ENV.fetch('LINE_SECRETARIANT_ID', nil).freeze

  test "通知されない（空き容量が41%以上）" do
    fake_df = "Filesystem  Size  Used Avail Use% Mounted on\n/dev/sda1   40G   10G   30G  25% /"
    DiskCheckJob.any_instance.stubs(:`).with("df / -h | tail -1").returns(fake_df)

    LineHookService.expects(:push_message).never
    perform_enqueued_jobs { DiskCheckJob.perform_now }
  end

  test "通知される（空き容量が20%）" do
    fake_df = "Filesystem  Size  Used Avail Use% Mounted on\n/dev/sda1   40G   32G   8G  80% /"
    DiskCheckJob.any_instance.stubs(:`).with("df / -h | tail -1").returns(fake_df)

    LineHookService.expects(:push_message).with(LINE_ID, includes("🟧"))
    perform_enqueued_jobs { DiskCheckJob.perform_now }
  end

  test "通知される（空き容量が5%）" do
    fake_df = "Filesystem  Size  Used Avail Use% Mounted on\n/dev/sda1   40G   38G   2G  95% /"
    DiskCheckJob.any_instance.stubs(:`).with("df / -h | tail -1").returns(fake_df)

    LineHookService.expects(:push_message).with(LINE_ID, includes("🟥"))
    perform_enqueued_jobs { DiskCheckJob.perform_now }
  end
end
