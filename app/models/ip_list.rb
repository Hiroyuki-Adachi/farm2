# == Schema Information
#
# Table name: ip_lists
#
#  id                                    :bigint           not null, primary key
#  block_count(ブロック回数)             :integer          default(0), not null
#  confirmation_expired_at(確認有効期限) :datetime
#  confirmation_token(トークン)          :string(6)        default(""), not null
#  created_by(作成者)                    :integer          default(0), not null
#  expired_on(有効期限)                  :date
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
class IpList < ApplicationRecord
  BLOCK_LIMIT = 3
  LOCAL_ADDRESSES = [
    IPAddr.new('127.0.0.1/32'),      # IPv4 local host
    IPAddr.new('10.0.0.0/8'),        # IPv4 private network(class A)
    # IPAddr.new('172.16.0.0/12'),     # IPv4 private network(class B)
    IPAddr.new('192.168.0.0/16'),    # IPv4 private network(class C)
    IPAddr.new('::1/128'),           # IPv6 local host
    IPAddr.new('fc00::/7'),          # IPv6 unique local addresses
    IPAddr.new('fe80::/10')          # IPv6 link-local addresses
  ].freeze

  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by'

  scope :whites, -> { 
    where('expired_on IS NOT NULL AND expired_on >= ?', Date.today)
    .where(white_flag: true)
    .pluck(:ip_address)
  }

  scope :blacks, -> { 
    where(white_flag: false, expired_on: nil)
    .where('block_count >= ?', BLOCK_LIMIT)
    .pluck(:ip_address)
  }

  def self.block_ip!(ip_address)
    return if LOCAL_ADDRESSES.any? { |ip| ip.include?(ip_address) }
    ip = find_or_initialize_by(ip_address: ip_address)
    ip.white_flag = false
    ip.block_count += 1
    ip.save
  end

  def self.white_ip!(ip_address, user)
    return if LOCAL_ADDRESSES.any? { |ip| ip.include?(ip_address) }
    ip = find_or_initialize_by(ip_address: ip_address)
    ip.white_flag = true
    ip.confirmation_token = SecureRandom.random_number(10**6).to_s.rjust(6, '0')
    ip.expired_on = nil
    ip.created_by = user.id
    ip.mail = user.mail
    ip.confirmation_expired_at = 10.minutes.from_now
    ip.save
    return ip
  end

  def self.confirm!(user, token)
    where(mail: user.mail)
    .where("current_timestamp <= mail_confirmation_expired_at")
    .find_by(confirmation_token: token)
    &.update(expired_on: Time.now.advance(months: 1).to_date)
  end

  def self.white_list
    Rails.cache.fetch('white_list', expires_in: 1.hour) do
      LOCAL_ADDRESSES | whites.map { |ip| IPAddr.new(ip) }
    end
  end

  def self.black_list
    Rails.cache.fetch('black_list', expires_in: 1.hour) do
      blacks.map { |ip| IPAddr.new(ip) }
    end
  end
end
