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
#  password_digest(パスワード)                              :string(128)      not null
#  target_from(開始年月)                                    :date             default(Fri, 01 Jan 2010), not null
#  target_to(終了年月)                                      :date             default(Fri, 31 Dec 2010), not null
#  term(期)                                                 :integer          default(0), not null
#  token(アクセストークン)                                  :string(36)       default(""), not null
#  view_month(表示切替月)                                   :integer          default([1, 4, 8]), not null, is an Array
#  created_at                                               :datetime         not null
#  updated_at                                               :datetime         not null
#  organization_id(組織)                                    :integer          default(0), not null
#  permission_id(権限)                                      :integer          default(0), not null
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
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "メールアドレス設定" do
    user = users(:user_manager)
    user.mail = 'user@example.com'
    user.save!

    assert_not_nil user.mail_confirmation_token
    assert_not_nil user.mail_confirmation_expired_at
    assert_operator user.mail_confirmation_expired_at, :>, Time.current
    assert_nil user.mail_confirmed_at
  end

  test "メールアドレス承認(OK)" do
    user = users(:user_manager)
    user.mail = 'user_ok@example.com'
    user.save!

    result = user.mail_confirm!(user.mail_confirmation_token)

    assert result
    assert_not_nil user.mail_confirmed_at
    assert_equal user.worker.pc_mail, user.mail
  end

  test "メールアドレス承認(NG)" do
    user = users(:user_manager)
    user.mail = 'user_ng@example.com'
    user.save!

    result = user.mail_confirm!("invalid_token")

    assert_not result
    assert_nil user.mail_confirmed_at
  end
end
