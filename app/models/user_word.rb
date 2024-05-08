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
class UserWord < ApplicationRecord
  belongs_to :user

  before_create :nop_empty_words
  before_update :remove_empty_words

  private

  def nop_empty_words
    logger.debug "nop_empty_words"
    throw(:abort) if self.word.blank?
  end

  def remove_empty_words
    logger.debug "remove_empty_words"
    self.destroy if self.word.blank?
  end
end
