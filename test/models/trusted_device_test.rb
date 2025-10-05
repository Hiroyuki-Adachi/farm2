# == Schema Information
#
# Table name: trusted_devices
#
#  id                                      :bigint           not null, primary key
#  device_name(デバイス名)                 :string(64)       default(""), not null
#  ip_address(IPアドレス)                  :string(64)       not null
#  last_used_at(最終使用日時)              :datetime         not null
#  token_digest(トークンのダイジェスト)    :string(128)      not null
#  ua_hash(ユーザーエージェントのハッシュ) :string(128)      not null
#  created_at                              :datetime         not null
#  updated_at                              :datetime         not null
#  user_id(ユーザーID)                     :bigint           not null
#
# Indexes
#
#  index_trusted_devices_on_token_digest  (token_digest) UNIQUE
#  index_trusted_devices_on_user_id       (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "test_helper"

class TrustedDeviceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
