# == Schema Information
#
# Table name: topics(トピック)
#
#  id                          :bigint           not null, primary key
#  content(内容)               :text
#  posted_on(投稿日)           :date             not null
#  title(タイトル)             :string(512)      default(""), not null
#  url(URL)                    :string(512)      default(""), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  topic_type_id(トピック種別) :integer          default(0), not null
#
# Indexes
#
#  index_topics_on_title_and_content_pgroonga  (((((COALESCE(title, ''::character varying))::text || ' '::text) || COALESCE(content, ''::text)))) USING pgroonga
#  index_topics_on_url                         (url) UNIQUE
#
class Topic < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to_active_hash :topic_type
  has_many :user_topics, dependent: :destroy

  scope :old, ->(days) { where(["posted_on < ?", Time.zone.today - days]) }
end
