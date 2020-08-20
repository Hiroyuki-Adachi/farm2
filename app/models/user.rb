# == Schema Information
#
# Table name: users # 利用者マスタ
#
#  id(利用者マスタ)              :integer          not null, primary key
#  calendar_term(期(カレンダー)) :integer          default(2018), not null
#  login_name(ログイン名)        :string(12)       not null
#  password_digest(パスワード)   :string(128)      not null
#  target_from(開始年月)         :date             default(Fri, 01 Jan 2010), not null
#  target_to(終了年月)           :date             default(Fri, 31 Dec 2010), not null
#  term(期)                      :integer          default(0), not null
#  view_month(表示切替月)        :integer          default(["1", "4", "8"]), not null, is an Array
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
#

class User < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :worker
  belongs_to :organization
  belongs_to :permission

  has_many :calendar_work_kinds, dependent: :destroy

  validates :login_name, uniqueness: true
  validates_length_of :password, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED

  def login_name=(value)
    super(value.downcase)
  end

  def admin?
    permission == Permission::ADMIN
  end

  def manager?
    permission == Permission::MANAGER
  end

  def checker?
    permission == Permission::CHECKER
  end

  def user?
    permission == Permission::USER
  end

  def visitor?
    permission == Permission::VISITOR
  end

  def manageable?
    admin? || manager?
  end

  def checkable?
    admin? || manager? || checker?
  end

  has_secure_password
end
