# == Schema Information
#
# Table name: work_kind_prices
#
#  id           :integer          not null, primary key
#  term         :integer          not null
#  work_kind_id :integer          not null
#  price        :decimal(5, )     default("1000"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
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
