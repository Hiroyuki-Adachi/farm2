# == Schema Information
#
# Table name: qr_login_sessions(QRログインセッション)
#
#  id                                                          :bigint           not null, primary key
#  consumed_at(セッション使用日時)                             :datetime
#  expires_at(セッション有効期限)                              :datetime         not null
#  status(セッション状態（0: 有効, 1: 使用済み, 2: 期限切れ）) :integer          default("pending"), not null
#  token(セッション識別子)                                     :string(36)       not null
#  created_at                                                  :datetime         not null
#  updated_at                                                  :datetime         not null
#  user_id(ユーザーID)                                         :integer
#
# Indexes
#
#  index_qr_login_sessions_on_token  (token) UNIQUE
#
class QrLoginSession < ApplicationRecord
  enum :status, { pending: 0, approved: 1, consumed: 2 }, default: :pending

  validates :token, presence: true, uniqueness: true

  before_validation :ensure_token, on: :create
  before_validation :ensure_expires_at, on: :create

  scope :alive, -> { where(expires_at: Time.current..).where(status: :pending) }

  scope :deletable, ->(now: Time.current, expired_keep: 1.day, consumed_keep: 30.days) do
    where(consumed_at: nil).where(expires_at: ...(now - expired_keep))
      .or(where.not(consumed_at: nil).where(consumed_at: ...(now - consumed_keep)))
  end

  def expired?
    expires_at < Time.current
  end

  def usable?
    pending? && !expired?
  end

  private

  def ensure_token
    self.token ||= SecureRandom.uuid # UUIDv4
  end

  def ensure_expires_at
    self.expires_at ||= 5.minutes.from_now
  end
end
