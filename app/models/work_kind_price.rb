# == Schema Information
#
# Table name: work_kind_prices(作業単価マスタ)
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

  def self.price(work_kind, term)
    work_kind_price = WorkKindPrice.find_by(work_kind_id: work_kind.id, term: term)
    return work_kind_price.price if work_kind_price
    system = System.find_by(term: term)
    return system.default_price if system
    return 0
  end
end
