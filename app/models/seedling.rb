# == Schema Information
#
# Table name: seedlings
#
#  id(育苗)                :integer          not null, primary key
#  seed_cost(種子原価)     :decimal(6, )     default(0), not null
#  soil_quantity(育苗土数) :decimal(4, )     default(0), not null
#  term(年度(期))          :integer          not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  work_type_id(作業分類)  :integer
#
# Indexes
#
#  index_seedlings_on_term_and_work_type_id  (term,work_type_id) UNIQUE
#

class Seedling < ActiveRecord::Base
  belongs_to :work_type, -> {with_deleted}
  has_many :seedling_homes, dependent: :destroy

  scope :usual, ->(term, work_types) {where(term: term, work_type_id: work_types.ids)}
  scope :by_term, ->(term) {where(term: term)}

  accepts_nested_attributes_for :seedling_homes, allow_destroy: true, reject_if: :reject_seedling_homes

  def reject_seedling_homes(attributes)
    attributes[:home_id].blank?
  end

  def work_type_name
    work_type&.name
  end
end
