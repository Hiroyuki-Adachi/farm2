# == Schema Information
#
# Table name: depreciations
#
#  id         :integer          not null, primary key
#  term       :integer          not null
#  machine_id :integer
#  cost       :decimal(9, )     default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_depreciations_on_term_and_machine_id  (term,machine_id) UNIQUE
#

class Depreciation < ApplicationRecord
  belongs_to :machine
  has_one :machine_type, through: :machine
  has_many :depreciation_types, dependent: :destroy
  has_many :work_types, through: :depreciation_types

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
