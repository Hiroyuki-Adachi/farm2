# == Schema Information
#
# Table name: ip_lists
#
#  id                               :bigint           not null, primary key
#  block_count(ブロック回数)        :integer          default(0), not null
#  block_flag(ブロックフラグ)       :boolean          default(FALSE), not null
#  confirmation_token(トークン)     :string(64)       default(""), not null
#  created_by(作成者)               :integer          default(0), not null
#  expired_on(有効期限)             :date
#  ip_address(IP Address)           :string(64)       default(""), not null
#  mail(メールアドレス)             :string(255)      default(""), not null
#  white_flag(ホワイトリストフラグ) :boolean          default(FALSE), not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#
# Indexes
#
#  ixdex_ip_lists_on_ip_address  (ip_address) UNIQUE
#
class IpList < ApplicationRecord
end