require "test_helper"

class CleanQrLoginSessionsJobTest < ActiveJob::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test "perform deletes deletable sessions" do
    freeze_time Time.current do
      deletable1 = QrLoginSession.create!(consumed_at: nil, expires_at: 2.days.ago, status: :pending)
      deletable2 = QrLoginSession.create!(consumed_at: 31.days.ago, expires_at: 40.days.ago, status: :consumed)
      keep = QrLoginSession.create!(consumed_at: nil, expires_at: 5.minutes.from_now, status: :pending)

      assert_difference "QrLoginSession.count", -2 do
        CleanQrLoginSessionsJob.perform_now
      end

      assert_nil QrLoginSession.find_by(id: deletable1.id)
      assert_nil QrLoginSession.find_by(id: deletable2.id)
      assert_equal keep.id, QrLoginSession.find_by(id: keep.id)&.id
    end
  end
end
