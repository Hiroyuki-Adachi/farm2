# == Schema Information
#
# Table name: web_push_subscriptions(WebPush購読情報)
#
#  id                            :bigint           not null, primary key
#  auth(認証鍵)                  :string           not null
#  endpoint(Push endpoint)       :text             not null
#  expiration_time(購読有効期限) :datetime
#  last_used_at(最終送信日時)    :datetime
#  p256dh(公開鍵)                :string           not null
#  user_agent(利用端末)          :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id(利用者)               :bigint           not null
#
# Indexes
#
#  index_web_push_subscriptions_on_endpoint              (endpoint) UNIQUE
#  index_web_push_subscriptions_on_user_id               (user_id)
#  index_web_push_subscriptions_on_user_id_and_endpoint  (user_id,endpoint) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class WebPushSubscription < ApplicationRecord
  belongs_to :user

  validates :endpoint, presence: true, uniqueness: true
  validates :p256dh, presence: true
  validates :auth, presence: true
end
