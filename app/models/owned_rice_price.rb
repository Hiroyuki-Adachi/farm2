# == Schema Information
#
# Table name: owned_rice_prices
#
#  id                       :bigint           not null, primary key
#  display_order(表示順)    :integer          default(0), not null
#  name(品種名)             :string(10)       default(""), not null
#  owned_price(保有米価格)  :decimal(5, )     default(0), not null
#  short_name(品種名(略称)) :string(5)        default(""), not null
#  term(年度(期))           :integer          not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  work_type_id(品種)       :integer          default(0), not null
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
