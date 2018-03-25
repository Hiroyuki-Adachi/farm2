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

  has_secure_password
end
