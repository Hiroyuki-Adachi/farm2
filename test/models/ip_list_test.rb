# == Schema Information
#
# Table name: ip_lists(IPアドレスリスト)
#
#  id                                    :bigint           not null, primary key
#  block_count(ブロック回数)             :integer          default(0), not null
#  confirmation_expired_at(確認有効期限) :datetime
#  created_by(作成者)                    :integer          default(0), not null
#  expired_on(有効期限)                  :date
#  hashed_token(ハッシュ化トークン)      :string(64)       default(""), not null
#  ip_address(IP Address)                :string(64)       default(""), not null
#  mail(メールアドレス)                  :string(255)      default(""), not null
#  white_flag(ホワイトリストフラグ)      :boolean          default(FALSE), not null
#  created_at                            :datetime         not null
#  updated_at                            :datetime         not null
#
# Indexes
#
#  ixdex_ip_lists_on_ip_address  (ip_address) UNIQUE
#
require "test_helper"

class IpListTest < ActiveSupport::TestCase
  setup do
    @user = users(:users1)
  end

  test "ブラックリスト(登録)" do
    assert_difference('IpList.count') do
      IpList.block_ip!('1.2.3.4')
    end

    ip = IpList.last
    assert_equal '1.2.3.4', ip.ip_address
    assert_equal false, ip.white_flag
    assert_equal 1, ip.block_count

    assert_no_difference('IpList.count') do
      IpList.block_ip!('1.2.3.4')
    end

    ip = IpList.last
    assert_equal '1.2.3.4', ip.ip_address
    assert_equal 2, ip.block_count
  end

  test "ブラックリスト(ローカルIP除外)" do
    assert_empty IpList.where(ip_address: '127.0.0.1', white_flag: false)

    assert_no_difference('IpList.count') do
      IpList.block_ip!('127.0.0.1')
    end
  end

  test "ホワイトリスト(登録)" do
    assert_difference('IpList.count') do
      IpList.white_ip!('2.3.4.5', @user)
    end

    ip = IpList.last
    assert_equal '2.3.4.5', ip.ip_address
    assert_equal true, ip.white_flag
    assert_equal @user.id, ip.created_by
    assert_equal @user.login_name, ip.mail
    assert_not_nil ip.hashed_token
    assert_operator ip.confirmation_expired_at, :>, Time.current
    assert_nil ip.expired_on
  end

  test "ホワイトリスト(ローカルIP除外)" do
    assert_empty IpList.where(ip_address: '127.0.0.1', white_flag: true)

    assert_no_difference('IpList.count') do
      IpList.white_ip!('127.0.0.1', @user)
    end
  end

  test "ホワイトリスト(認証)" do
    ip = IpList.white_ip!('2.3.4.5', @user)
    ip.token = "123456"
    ip.save!

    assert_equal true, ip.authenticate?("123456")
    assert_equal false, ip.authenticate?("654321")
  end
end
