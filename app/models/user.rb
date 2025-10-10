# == Schema Information
#
# Table name: users(利用者マスタ)
#
#  id(利用者マスタ)                                         :integer          not null, primary key
#  calendar_term(期(カレンダー))                            :integer          default(2018), not null
#  login_name(ログイン名)                                   :string(12)       not null
#  mail(メールアドレス)                                     :string(255)      default(""), not null
#  mail_confirmation_expired_at(メールアドレス確認有効期限) :datetime
#  mail_confirmation_token(メールアドレス確認トークン)      :string(64)
#  mail_confirmed_at(メールアドレス確認日時)                :datetime
#  otp_enabled(2段階認証フラグ)                             :boolean          default(FALSE), not null
#  otp_last_used_at(2段階認証 最終使用日時)                 :datetime
#  otp_secret(2段階認証 秘密鍵)                             :json
#  password_digest(パスワード)                              :string(128)      not null
#  target_from(開始年月)                                    :date             default(Fri, 01 Jan 2010), not null
#  target_to(終了年月)                                      :date             default(Fri, 31 Dec 2010), not null
#  term(期)                                                 :integer          default(0), not null
#  theme(画面テーマ)                                        :integer          default("light"), not null
#  token(アクセストークン)                                  :string(36)       default(""), not null
#  view_month(表示切替月)                                   :integer          default([1, 4, 8]), not null, is an Array
#  created_at                                               :datetime         not null
#  updated_at                                               :datetime         not null
#  line_id                                                  :string(50)       default(""), not null
#  organization_id(組織)                                    :integer          default(0), not null
#  permission_id(権限)                                      :integer          default("visitor"), not null
#  worker_id(作業者)                                        :integer
#
# Indexes
#
#  index_users_on_login_name            (login_name) UNIQUE
#  index_users_on_worker_id             (worker_id) UNIQUE
#  ix_users_on_mail                     (mail) UNIQUE WHERE ((mail)::text <> ''::text)
#  ix_users_on_mail_confirmation_token  (mail_confirmation_token) UNIQUE WHERE (mail_confirmation_token IS NOT NULL)
#  ix_users_token                       (token) UNIQUE
#
require "rotp"
class User < ApplicationRecord
  before_create :set_token
  before_update :clear_mail_fields, if: -> { mail_changed? && self.mail.present? }
  after_update :set_pc_mail, if: -> { saved_change_to_mail_confirmed_at? && self.mail_confirmed_at.present? }

  has_secure_password
  encrypts :otp_secret

  enum :permission_id, { visitor: 0, user: 1, checker: 2, manager: 3, admin: 9 }
  enum :theme, { light: 0, dark: 1, auto: 2 }

  scope :linable, -> { where.not(line_id: '') }

  belongs_to :worker
  belongs_to :organization

  has_many :calendar_work_kinds, dependent: :destroy
  has_many :user_words, dependent: :destroy
  has_many :user_topics, dependent: :destroy
  has_many :topics, through: :user_topics

  accepts_nested_attributes_for :user_words

  validates :login_name, uniqueness: true
  validates :password, length: { maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED }

  def login_name=(value)
    super(value.downcase)
  end

  def userable?
    admin? || manager? || checker? || user?
  end

  def manageable?
    admin? || manager?
  end

  def checkable?
    admin? || manager? || checker?
  end

  def mail_confirmed?
    self.mail_confirmed_at.present?
  end

  def mail_confirm!(mail_confirmation_token)
    return false if self.mail_confirmation_token != mail_confirmation_token
    return false if self.mail_confirmation_expired_at.nil? || self.mail_confirmation_expired_at < Time.current

    self.update(mail_confirmed_at: Time.current)
  end

  def self.find_by_mail(mail)
    User.where.not(mail_confirmed_at: nil).find_by(mail: mail)
  end

  def linable?
    self.line_id.present?
  end

  def current_mail_status
    return :not_entered if mail.blank?
    return :confirmed if mail_confirmed_at.present?
    return :expired if mail_confirmation_expired_at.present? && mail_confirmation_expired_at < Time.current
    :pending
  end

  def totp
    return if otp_secret.blank?
    ROTP::TOTP.new(otp_secret, issuer: ENV.fetch("OTP_SECRET_ISSUER"))
  end

  def totp_verify?(code)
    return false if totp.blank?
    return false if otp_last_used_at.present? && otp_last_used_at > 30.seconds.ago

    if totp.verify(code, drift_behind: 30, drift_ahead: 30)
      update(otp_last_used_at: Time.current)
      true
    else
      false
    end
  end

  def prepare_totp_secret!
    update!(otp_secret: ROTP::Base32.random_base32) unless otp_enabled
  end

  def enable_totp!
    update!(otp_enabled: true) if otp_secret.present?
  end

  def destroy_totp!
    update!(otp_enabled: false, otp_secret: nil, otp_last_used_at: nil)
  end

  private

  def set_token
    self.token = SecureRandom.uuid
  end

  def clear_mail_fields
    self.mail_confirmation_token = SecureRandom.uuid
    self.mail_confirmation_expired_at = 1.day.from_now
    self.mail_confirmed_at = nil
  end

  def set_pc_mail
    self.worker.update(pc_mail: mail) if self.mail.present? && self.worker.present? && self.worker.pc_mail.blank?
  end
end
