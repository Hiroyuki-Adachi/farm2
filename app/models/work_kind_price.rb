# == Schema Information
#
# Table name: work_kind_prices
#
#  id(作業単価マスタ)     :integer          not null, primary key
#  price(単価)            :decimal(5, )     default(1000), not null
#  term(年度(期))         :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  work_kind_id(作業種別) :integer          not null
#
# Indexes
#
#  index_work_kind_prices_on_term_and_work_kind_id  (term,work_kind_id) UNIQUE
#

class WorkKindPrice < ApplicationRecord
  belongs_to :work_kind

  validates :price, presence: true
  validates :price, numericality: true, if: proc { |x| x.price.present?}

  scope :usual, ->(work_kind) {where("work_kind_id = ? and term <= ?", work_kind.id, Organization.term).order("term DESC")}
  scope :by_term, ->(work_kind, term) {where("work_kind_id = ? and term <= ?", work_kind.id, term).order("term DESC")}
end
