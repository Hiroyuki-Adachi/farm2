# == Schema Information
#
# Table name: expense_types(経費種別)
#
#  id                        :bigint           not null, primary key
#  chemical_flag(薬剤フラグ) :boolean          default(FALSE), not null
#  deleted_at(削除年月日)    :datetime
#  display_order(表示順)     :integer          default(0), not null
#  name(経費種別名称)        :string(10)       default(""), not null
#  other_flag(その他フラグ)  :boolean          default(FALSE), not null
#  sales_flag(売上フラグ)    :boolean          default(FALSE), not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

class ExpenseType < ApplicationRecord
  include Discard::Model
  self.discard_column = :deleted_at

  scope :usual, -> {kept.order(display_order: :ASC, id: :ASC)}
  scope :with_deleted, -> { with_discarded }
  scope :only_deleted, -> { with_discarded.discarded }

  def self.chemical_id
    return ExpenseType.find_by(chemical_flag: true, sales_flag: false)&.id || 0
  end
end
