# == Schema Information
#
# Table name: user_words(利用者ワード)
#
#  id                            :bigint           not null, primary key
#  line_flag(LINEフラグ)         :boolean          default(FALSE), not null
#  pc_flag(パソコンフラグ)       :boolean          default(TRUE), not null
#  sp_flag(スマートフォンフラグ) :boolean          default(TRUE), not null
#  word(ワード)                  :string(128)      default(""), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id(利用者ID)             :integer          not null
#
# Indexes
#
#  index_user_words_on_word             (word)
#  index_user_words_on_word_by_user_id  (user_id,word) UNIQUE
#
class UserWord < ApplicationRecord
  belongs_to :user

  before_save :trim_word
  after_save :remove_empty_words

  scope :by_word, ->(word) { where(word: word) }

  validates :word, length: { maximum: 128 }
  validates :word, uniqueness: { scope: :user_id }

  def self.words
    distinct.pluck(:word)
  end

  def self.match_all_topics!
    words.each do |word|
      Topic.by_word(word).find_each do |topic|
        by_word(word).find_each do |user_word|
          UserTopic.find_or_create_by(user_id: user_word.user_id, topic_id: topic.id) do |user_topic|
            user_topic.word = word
            user_topic.pc_flag = user_word.pc_flag
            user_topic.sp_flag = user_word.sp_flag
            user_topic.line_flag = user_word.line_flag
          end
        end
      end
    end
  end

  private

  def trim_word
    self.word = self.word.strip
  end

  def remove_empty_words
    if self.word.blank?
      self.destroy
      UserTopic.where(user_id: self.user_id, word: self.word_before_last_save)&.destroy_all
    end
  end
end
