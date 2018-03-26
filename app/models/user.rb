# == Schema Information
#
# Table name: users # 利用者マスタ
#
#  id              :integer          not null, primary key # 利用者マスタ
#  login_name      :string(12)       not null              # ログイン名
#  password_digest :string(128)      not null              # パスワード
#  worker_id       :integer                                # 作業者
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
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
