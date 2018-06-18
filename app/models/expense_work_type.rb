# == Schema Information
#
# Table name: expense_work_types # 経費作業種別
#
#  id           :integer          not null, primary key  # 経費作業種別
#  expense_id   :integer                                 # 経費
#  work_type_id :integer                                 # 作業分類
#  rate         :decimal(5, 2)    default(0.0), not null # 割合
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ExpenseWorkType < ActiveRecord::Base
  belongs_to :expense
  belongs_to :work_type, -> {with_deleted}
end
