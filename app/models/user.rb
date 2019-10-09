# == Schema Information
#
# Table name: users # 利用者マスタ
#
#  id              :integer          not null, primary key
#  login_name      :string(12)       not null                                        # ログイン名
#  password_digest :string(128)      not null                                        # パスワード
#  worker_id       :integer                                                          # 作業者
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  term            :integer          default(0), not null                            # 期
#  target_from     :date             default(Fri, 01 Jan 2010), not null             # 開始年月
#  target_to       :date             default(Fri, 31 Dec 2010), not null             # 終了年月
#  organization_id :integer          default(0), not null                            # 組織
#  permission_id   :integer          default(0), not null                            # 権限
#  view_month      :integer          default(["1", "4", "8"]), not null, is an Array # 表示切替月
#  calendar_term   :integer          default(2018), not null                         # 期(カレンダー)
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
