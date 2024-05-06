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
require "test_helper"

class TopicTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
