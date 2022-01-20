# == Schema Information
#
# Table name: owned_rice_prices
#
#  id            :integer          not null, primary key
#  term          :integer          not null
#  work_type_id  :integer          default("0"), not null
#  display_order :integer          default("0"), not null
#  name          :string(10)       default(""), not null
#  short_name    :string(5)        default(""), not null
#  owned_price   :decimal(5, )     default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  owned_rice_prices_2nd  (term,work_type_id) UNIQUE
#

class OwnedRicePrice < ApplicationRecord
  belongs_to :work_type

  has_many   :owned_rices, dependent: :destroy

  scope :usual, ->(term) {where(term: term).order(:display_order)}
end
