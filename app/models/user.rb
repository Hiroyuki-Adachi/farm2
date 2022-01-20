# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  login_name      :string(12)       not null
#  password_digest :string(128)      not null
#  worker_id       :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  term            :integer          default("0"), not null
#  target_from     :date             default("2010-01-01"), not null
#  target_to       :date             default("2010-12-31"), not null
#  organization_id :integer          default("0"), not null
#  permission_id   :integer          default("0"), not null
#  view_month      :integer          default("{1,4,8}"), not null, is an Array
#  calendar_term   :integer          default("2018"), not null
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
  belongs_to_active_hash :permission

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
