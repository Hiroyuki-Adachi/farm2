# == Schema Information
#
# Table name: user_topics(利用者トピック)
#
#  id                    :bigint           not null, primary key
#  read_flag(既読フラグ) :boolean          default(FALSE), not null
#  word(ワード)          :string(128)      default(""), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  topic_id(トピックID)  :integer          not null
#  user_id(利用者ID)     :integer          not null
#
class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  scope :current_topics, ->(user) { 
    where(user_id: user.id).joins(:topic).order('topics.posted_on desc, topics.id desc').limit(10).includes(:topic)
  }

  def readed!
    update(read_flag: true)
  end
end
