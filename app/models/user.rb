# == Schema Information
#
# Table name: users(利用者マスタ)
#
#  id(利用者マスタ)              :integer          not null, primary key
#  calendar_term(期(カレンダー)) :integer          default(2018), not null
#  login_name(ログイン名)        :string(12)       not null
#  password_digest(パスワード)   :string(128)      not null
#  target_from(開始年月)         :date             default(Fri, 01 Jan 2010), not null
#  target_to(終了年月)           :date             default(Fri, 31 Dec 2010), not null
#  term(期)                      :integer          default(0), not null
#  token(アクセストークン)       :string(36)       default(""), not null
#  view_month(表示切替月)        :integer          default([1, 4, 8]), not null, is an Array
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  organization_id(組織)         :integer          default(0), not null
#  permission_id(権限)           :integer          default(0), not null
#  worker_id(作業者)             :integer
#
# Indexes
#
#  index_users_on_login_name  (login_name) UNIQUE
#  index_users_on_worker_id   (worker_id) UNIQUE
#  ix_users_token             (token) UNIQUE
#

class User < ApplicationRecord
  before_create :set_token

  enum :permission, { visitor: 0, user: 1, checker: 2, manager: 3, admin: 9 }

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

  def manageable?
    admin? || manager?
  end

  def checkable?
    admin? || manager? || checker?
  end

  def permission_name
    human_attribute_enum(:permission)
  end

  private

  def set_token
    self.token = SecureRandom.uuid
  end

  has_secure_password
end
