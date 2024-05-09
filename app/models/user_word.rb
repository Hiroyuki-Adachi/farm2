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

  after_save :remove_empty_words

  private

  def remove_empty_words
    self.destroy if self.word.blank?
  end
end
