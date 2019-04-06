# == Schema Information
#
# Table name: expense_types # 経費種別
#
#  id            :bigint(8)        not null, primary key
#  name          :string(10)       default(""), not null    # 経費種別名称
#  chemical_flag :boolean          default(FALSE), not null # 薬剤フラグ
#  sales_flag    :boolean          default(FALSE), not null # 売上フラグ
#  other_flag    :boolean          default(FALSE), not null # その他フラグ
#  display_order :integer          default(0), not null     # 表示順
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime                                  # 削除年月日
#

class ExpenseType < ApplicationRecord
  acts_as_paranoid

  scope :usual, -> {order(display_order: :ASC, id: :ASC)}

  def self.chemical_id
    return ExpenseType.find_by(chemical_flag: true, sales_flag: false)&.id || 0
  end
end
