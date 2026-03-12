# == Schema Information
#
# Table name: user_topics(利用者トピック)
#
#  id                            :bigint           not null, primary key
#  line_flag(LINEフラグ)         :boolean          default(FALSE), not null
#  pc_flag(パソコンフラグ)       :boolean          default(TRUE), not null
#  read_flag(既読フラグ)         :boolean          default(FALSE), not null
#  sp_flag(スマートフォンフラグ) :boolean          default(TRUE), not null
#  word(ワード)                  :string(128)      default(""), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  topic_id(トピックID)          :integer          not null
#  user_id(利用者ID)             :integer          not null
#
# Indexes
#
#  ix_user_topics_user_id_topic_id  (user_id,topic_id) UNIQUE
#
class UserTopic < ApplicationRecord
  belongs_to :user
  belongs_to :topic

  scope :current_topics, ->(user) { 
    where(user_id: user.id).joins(:topic).order('topics.posted_on desc, topics.id desc').limit(10).includes(:topic)
  }
  scope :pc, -> { where(pc_flag: true) }
  scope :sp, -> { where(sp_flag: true) }
  scope :line, -> { where(line_flag: true) }
  scope :readed, -> { where(read_flag: true) }
  scope :unreaded, -> { where(read_flag: false) }

  # トピックの既読フラグを立てる

  def readed!
    update(read_flag: true)
  end

  def readed?
    read_flag
  end
end
