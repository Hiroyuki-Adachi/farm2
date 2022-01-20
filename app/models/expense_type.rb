# == Schema Information
#
# Table name: expense_types
#
#  id            :integer          not null, primary key
#  name          :string(10)       default(""), not null
#  chemical_flag :boolean          default("false"), not null
#  sales_flag    :boolean          default("false"), not null
#  other_flag    :boolean          default("false"), not null
#  display_order :integer          default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#

class ExpenseType < ApplicationRecord
  acts_as_paranoid

  scope :usual, -> {order(display_order: :ASC, id: :ASC)}

  def self.chemical_id
    return ExpenseType.find_by(chemical_flag: true, sales_flag: false)&.id || 0
  end
end
