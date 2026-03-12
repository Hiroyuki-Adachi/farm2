require "test_helper"

class QrLoginSessionDeletableScopeTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test "セション使用日時がNULL で 使用期限 expired_keep より古い場合に deletable に含まれる" do
    freeze_time Time.current do
      old_expired = QrLoginSession.create!(consumed_at: nil, expires_at: 2.days.ago, status: :pending)
      recent_expired = QrLoginSession.create!(consumed_at: nil, expires_at: 12.hours.ago, status: :pending)
      alive = QrLoginSession.create!(consumed_at: nil, expires_at: 5.minutes.from_now, status: :pending)

      result = QrLoginSession.deletable(now: Time.current, expired_keep: 1.day, consumed_keep: 30.days)

      assert_includes result, old_expired
      assert_not_includes result, recent_expired
      assert_not_includes result, alive
    end
  end

  test "セション使用日時が古く、consumed_keep より古い場合に deletable に含まれる" do
    freeze_time Time.current do
      old_consumed = QrLoginSession.create!(status: :consumed, consumed_at: 31.days.ago, expires_at: 40.days.ago)
      recent_consumed = QrLoginSession.create!(status: :consumed, consumed_at: 10.days.ago, expires_at: 40.days.ago)

      result = QrLoginSession.deletable(now: Time.current, expired_keep: 1.day, consumed_keep: 30.days)

      assert_includes result, old_consumed
      assert_not_includes result, recent_consumed
    end
  end

  test "承認済みだが、使用期限が切れておらず、古い消費日時でもない場合は deletable に含まれない" do
    freeze_time Time.current do
      approved = QrLoginSession.create!(status: :approved, expires_at: 5.minutes.from_now, consumed_at: nil)

      result = QrLoginSession.deletable(now: Time.current)
      assert_not_includes result, approved
    end
  end
end
