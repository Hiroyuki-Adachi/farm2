# == Schema Information
#
# Table name: topics
#
#  id                :bigint           not null, primary key
#  content(内容)     :text
#  posted_on(投稿日) :date             not null
#  title(タイトル)   :string(512)      default(""), not null
#  url(URL)          :string(512)      default(""), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_topics_on_url  (url) UNIQUE
#
class Topic < ApplicationRecord
  has_many :user_topics, dependent: :destroy

  scope :old, ->(days) { where(["posted_on < ?", Time.zone.today - days]) }
end
