# == Schema Information
#
# Table name: user_tokens
#
#  id                    :bigint           not null, primary key
#  expires_at(有効期限)  :datetime         not null
#  token(トークン(UUID)) :string(36)       default(""), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id(利用者ID)     :integer          not null
#
# Indexes
#
#  index_user_tokens_on_user_id  (user_id) UNIQUE
#
require 'securerandom'
class UserToken < ApplicationRecord
  belongs_to :user

  before_save :set_token

  EXPIRES_AT = 10.minutes

  def expired?
    self.expires_at < Time.zone.now
  end

  private

  def set_token
    self.token = SecureRandom.uuid
    self.expires_at = default_expires_at
  end

  def default_expires_at
    Time.zone.now + EXPIRES_AT
  end
end
