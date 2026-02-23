# == Schema Information
#
# Table name: qr_login_sessions(QRログインセッション)
#
#  id                                                          :bigint           not null, primary key
#  expires_at(セッション有効期限)                              :datetime         not null
#  status(セッション状態（0: 有効, 1: 使用済み, 2: 期限切れ）) :integer          default(0), not null
#  token(セッション識別子)                                     :string           not null
#  created_at                                                  :datetime         not null
#  updated_at                                                  :datetime         not null
#  approved_user_id(承認したユーザーID)                        :integer
#  user_id(ユーザーID)                                         :integer          not null
#
# Indexes
#
#  index_qr_login_sessions_on_token  (token) UNIQUE
#
class QrLoginSession < ApplicationRecord
end
