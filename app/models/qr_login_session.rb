class QrLoginSession < ApplicationRecord
  enum :status, { pending: 0, approved: 1, consumed: 2, expired: 3 }, default: :pending

  before_validation :ensure_token, on: :create
  before_validation :set_default_expires_at, on: :create

  validates :token, presence: true, uniqueness: true,
                    format: { with: /\A[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\z/i }
  validates :expires_at, presence: true

  def expired?
    expires_at <= Time.current
  end

  private

  def ensure_token
    self.token ||= SecureRandom.uuid
  end

  def set_default_expires_at
    self.expires_at ||= 5.minutes.from_now
  end
end
