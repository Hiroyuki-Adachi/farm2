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
require "test_helper"

class UserTokenTest < ActiveSupport::TestCase
  test "トークンが既に存在する" do
    user = users(:users1)
    old_token = user.user_token.token
    assert_difference -> { UserToken.count }, 0 do
      user.regenerate_token!
    end
    assert_not_equal old_token, user.user_token.token
  end

  test "トークンが存在しない" do
    user = users(:user_manager)
    assert_difference -> { UserToken.count }, 1 do
      user.regenerate_token!
    end
    assert_not_empty user.user_token.token
  end
end
