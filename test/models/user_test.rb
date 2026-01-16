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
require 'test_helper'
require "rotp"

class UserTest < ActiveSupport::TestCase
  setup do
    @admin   = users(:users1)
    @manager = users(:user_manager)
    @checker = users(:user_checker)
    @user    = users(:user_user)
    @visitor = users(:user_visitor)
  end
  test "メールアドレス設定" do
    user = users(:user_manager)
    user.mail = 'user@example.com'
    user.save!

    assert_not_nil user.mail_confirmation_token
    assert_not_nil user.mail_confirmation_expired_at
    assert_operator user.mail_confirmation_expired_at, :>, Time.current
    assert_nil user.mail_confirmed_at
    assert_equal :pending, user.current_mail_status
  end

  test "メールアドレス承認(OK)" do
    user = users(:user_manager)
    user.mail = 'user_ok@example.com'
    user.save!

    result = user.mail_confirm!(user.mail_confirmation_token)

    assert result
    assert_not_nil user.mail_confirmed_at
    assert_equal user.worker.pc_mail, user.mail
    assert_equal :confirmed, user.current_mail_status
  end

  test "メールアドレス承認(NG)" do
    user = users(:user_manager)
    user.mail = 'user_ng@example.com'
    user.save!

    result = user.mail_confirm!("invalid_token")

    assert_not result
    assert_nil user.mail_confirmed_at
    assert_equal :pending, user.current_mail_status
  end

  test "メールアドレス承認(期限無し)" do
    user = users(:user_manager)
    user.mail = 'user_nil@example.com'
    user.save!
    user.update_column(:mail_confirmation_expired_at, nil)

    result = user.mail_confirm!(user.mail_confirmation_token)

    assert_not result
    assert_nil user.mail_confirmed_at
    assert_equal :pending, user.current_mail_status
  end

  test "メールアドレス承認(期限切れ)" do
    user = users(:user_manager)
    user.mail = 'user_expired@example.com'
    user.save!
    user.update_column(:mail_confirmation_expired_at, 1.day.ago)

    result = user.mail_confirm!(user.mail_confirmation_token)

    assert_not result
    assert_nil user.mail_confirmed_at
    assert_equal :expired, user.current_mail_status
  end

  test "権限別の判定" do
    {
      admin: @admin,
      manager: @manager,
      checker: @checker,
      user: @user,
      visitor: @visitor
    }.each do |role, u|
      assert_equal role == :admin,   u.admin?,   "#{role} admin?"
      assert_equal role == :manager, u.manager?, "#{role} manager?"
      assert_equal role == :checker, u.checker?, "#{role} checker?"
      assert_equal role == :user,    u.user?,    "#{role} user?"
      assert_equal role == :visitor, u.visitor?, "#{role} visitor?"
    end
  end

  test "権限の複合判定" do
    assert @admin.userable?
    assert @manager.userable?
    assert @checker.userable?
    assert @user.userable?
    assert_not @visitor.userable?

    assert @admin.manageable?
    assert @manager.manageable?
    assert_not @checker.manageable?
    assert_not @user.manageable?
    assert_not @visitor.manageable?

    assert @admin.checkable?
    assert @manager.checkable?
    assert @checker.checkable?
    assert_not @user.checkable?
    assert_not @visitor.checkable?
  end

  test "TOTP対応(フラグ設定)" do
    user = users(:user_manager)
    user.prepare_totp_secret!
    user.update!(otp_enabled: false)

    assert_not user.otp_enabled
    user.enable_totp!
    assert user.otp_enabled
  end

  test "TOTP対応(秘密鍵準備)" do
    user = users(:user_manager)
    user.update!(otp_secret: nil)
    assert_nil user.otp_secret

    user.prepare_totp_secret!
    assert_not_nil user.otp_secret
    assert_not_nil user.totp
    assert_instance_of ROTP::TOTP, user.totp
    assert_equal user.organization.name, user.totp.issuer
  end

  test "TOTP対応(シークレット生成:nil対応)" do
    user = User.new(otp_secret: nil)
    assert_nil user.totp
  end

  test "TOTP認証(成功時)" do
    totp = mock("totp")
    totp.expects(:verify)
        .with("123456", has_entries(drift_behind: 30, drift_ahead: 30))
        .returns(true)
    @user.stubs(:totp).returns(totp)

    assert_equal true, @user.totp_verify?("123456")
    assert_in_delta Time.current, @user.otp_last_used_at, 1.second
  end

  test "TOTP認証(失敗時)" do
    totp = mock("totp")
    totp.expects(:verify)
        .with("999999", has_entries(drift_behind: 30, drift_ahead: 30))
        .returns(false)
    @user.stubs(:totp).returns(totp)

    assert_equal false, @user.totp_verify?("999999")
    assert_nil @user.otp_last_used_at
  end

  test "TOTP認証(直前の成功から時間が経過していない場合)" do
    @user.update!(otp_last_used_at: 5.seconds.ago) # ← 30秒以内
    totp = mock("totp")
    totp.expects(:verify).never # 早期returnなので呼ばれない
    @user.stubs(:totp).returns(totp)

    assert_equal false, @user.totp_verify?("123456")
    assert_in_delta 5.seconds.ago.to_i, @user.otp_last_used_at.to_i, 1.second
  end

  test "TOTP認証(TOTPオブジェクトが存在しない場合)" do
    @user.stubs(:totp).returns(nil)

    assert_equal false, @user.totp_verify?("123456")
    assert_nil @user.otp_last_used_at
  end
end
