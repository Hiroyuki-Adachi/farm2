# == Schema Information
#
# Table name: expense_work_types
#
#  id           :integer          not null, primary key
#  expense_id   :integer
#  work_type_id :integer
#  rate         :decimal(5, 2)    default("0"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_expense_work_types_on_expense_id_and_work_type_id  (expense_id,work_type_id) UNIQUE
#

class ExpenseWorkType < ApplicationRecord
  belongs_to :expense
  belongs_to :work_type, -> {with_deleted}

  def true_rate
    rate.nil? || rate.zero? ? 1 : rate
  end

  def rate?
    !(rate.nil? || rate.zero?)
  end

  def work_type_name
    work_type&.name || ""
  end
end
