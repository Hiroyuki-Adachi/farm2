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
end
