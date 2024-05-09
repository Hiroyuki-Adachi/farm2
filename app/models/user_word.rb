# == Schema Information
#
# Table name: user_words
#
#  id                :bigint           not null, primary key
#  word(ワード)      :string(128)      default(""), not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  user_id(利用者ID) :integer          not null
#
# Indexes
#
#  index_user_words_on_word_by_user_id  (user_id,word) UNIQUE
#
class UserWord < ApplicationRecord
  belongs_to :user

  after_save :remove_empty_words

  validates :word, length: { maximum: 128 }
  validates :word, uniqueness: { scope: :user_id }

  private

  def remove_empty_words
    self.destroy if self.word.blank?
  end
end
