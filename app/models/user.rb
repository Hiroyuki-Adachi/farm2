# == Schema Information
#
# Table name: users # 利用者マスタ
#
#  id              :integer          not null, primary key               # 利用者マスタ
#  login_name      :string(12)       not null                            # ログイン名
#  password_digest :string(128)      not null                            # パスワード
#  worker_id       :integer                                              # 作業者
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  term            :integer          default(0), not null                # 期
#  target_from     :date             default(Fri, 01 Jan 2010), not null # 開始年月
#  target_to       :date             default(Fri, 31 Dec 2010), not null # 終了年月
#  organization_id :integer          default(0), not null                # 組織
#

class User < ActiveRecord::Base
  belongs_to :worker

  validates :login_name, uniqueness: true
  validates_length_of :password, maximum: ActiveModel::SecurePassword::MAX_PASSWORD_LENGTH_ALLOWED

  def login_name=(value)
    super(value.downcase)
  end

  has_secure_password
end
