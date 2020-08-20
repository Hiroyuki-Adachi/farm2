# == Schema Information
#
# Table name: depreciations # 減価償却
#
#  id(減価償却)     :integer          not null, primary key
#  cost(減価償却費) :decimal(9, )     default(0), not null
#  term(年度(期))   :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  machine_id(機械) :integer
#
# Indexes
#
#  index_depreciations_on_term_and_machine_id  (term,machine_id) UNIQUE
#

class Depreciation < ApplicationRecord
  belongs_to :machine
  has_one :machine_type, {through: :machine}
  has_many :depreciation_types, {dependent: :destroy}
  has_many :work_types, {through: :depreciation_types}

  scope :usual, ->(term) {joins(:machine, :machine_type).where(["depreciations.term = ?", term])}

  def regist_work_types(work_types)
    work_types.each do |work_type|
      unless depreciation_types.find_by(work_type_id: work_type)
        DepreciationType.create(depreciation_id: id, work_type_id: work_type)
      end
    end
    depreciation_types.where.not(work_type_id: work_types).each(&:destroy)
  end
end
