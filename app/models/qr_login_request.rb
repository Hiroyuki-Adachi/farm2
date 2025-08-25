# == Schema Information
#
# Table name: qr_login_requests(QRログインリクエスト)
#
#  id                               :bigint           not null, primary key
#  approved_at(承認日時)            :datetime
#  expires_at(有効期限)             :datetime         not null
#  ip(IPアドレス)                   :string(45)       default(""), not null
#  pc_nonce(PC用ノンス)             :string(64)       default(""), not null
#  token(一時トークン)              :string(64)       not null
#  used_at(確定日時)                :datetime
#  user_agent(ユーザーエージェント) :text             default(""), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  approved_by_id(承認者ID)         :bigint
#
# Indexes
#
#  index_qr_login_requests_on_approved_by_id  (approved_by_id)
#  index_qr_login_requests_on_expires_at      (expires_at)
#  index_qr_login_requests_on_token           (token) UNIQUE
#  index_qr_login_requests_on_used_at         (used_at)
#
class QrLoginRequest < ApplicationRecord
  belongs_to :approved_by, class_name: "User", optional: true

  has_secure_token # token を最終確定POSTで使う（使い捨て）

  before_create :set_expiry

  def expired?
    Time.current >= expires_at
  end

  def approvable?
    approved_at.nil? && !expired?
  end

  def consumable?
    approved_at.present? && used_at.nil? && !expired?
  end

  private

  def set_expiry
    self.expires_at ||= 2.minutes.from_now
  end
end
