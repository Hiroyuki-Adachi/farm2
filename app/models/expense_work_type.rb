# == Schema Information
#
# Table name: expense_work_types(経費作業種別)
#
#  id(経費作業種別)       :integer          not null, primary key
#  rate(割合)             :decimal(5, 2)    default(0.0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  expense_id(経費)       :integer
#  organization_id(組織)  :bigint
#  work_type_id(作業分類) :integer
#
# Indexes
#
#  index_expense_work_types_on_expense_id_and_work_type_id  (expense_id,work_type_id) UNIQUE
#  index_expense_work_types_on_organization_id              (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class ExpenseWorkType < ApplicationRecord
  belongs_to :organization, optional: true
  belongs_to :expense
  belongs_to :work_type, -> { with_deleted }

  before_validation :set_organization_from_expense

  scope :for_organization, lambda { |organization|
    organization_id = organization.is_a?(Organization) ? organization.id : organization
    where(organization_id: organization_id)
  }

  def true_rate
    rate.nil? || rate.zero? ? 1 : rate
  end

  def rate?
    !(rate.nil? || rate.zero?)
  end

  def work_type_name
    work_type&.name || ""
  end

  private

  def set_organization_from_expense
    self.organization_id = expense.organization_id if expense
  end
end
