require "test_helper"

class QrLoginSessionTest < ActiveSupport::TestCase
  include ActiveSupport::Testing::TimeHelpers

  test "トークンと有効期限が自動生成されること" do
    freeze_time Time.current do
      qr = QrLoginSession.new
      assert qr.valid?
      assert_not_nil qr.token
      assert_not_nil qr.expires_at
      assert_equal :pending, qr.status.to_sym
    end
  end

  test "トークンは一意であること" do
    token = SecureRandom.uuid
    QrLoginSession.create!(token: token)

    qr = QrLoginSession.new(token: token)
    assert_not qr.valid?
  end

  test "expired_atが過去の場合、expired?はtrueを返すこと" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(expires_at: 1.minute.ago)
      assert qr.expired?
    end
  end

  test "expired_atが未来の場合、expired?はfalseを返すこと" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(expires_at: 1.minute.from_now)
      assert_not qr.expired?
    end
  end

  test "pendingかつ未期限切れの場合、usable?はtrueを返すこと" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :pending, expires_at: 1.minute.from_now)
      assert qr.usable?
    end
  end

  test "approvedの場合、usable?はfalseを返すこと" do
    qr = QrLoginSession.create!(status: :approved)
    assert_not qr.usable?
  end

  test "expiredの場合、usable?はfalseを返すこと" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :pending, expires_at: 1.minute.ago)
      assert_not qr.usable?
    end
  end
end
