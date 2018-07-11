# == Schema Information
#
# Table name: total_costs # 集計原価
#
#  id                 :bigint(8)        not null, primary key
#  term               :integer          not null              # 年度(期)
#  total_cost_type_id :integer          not null              # 集計原価種別
#  occurred_on        :date             not null              # 発生日
#  work_id            :integer                                # 作業
#  expense_id         :integer                                # 経費
#  depreciation_id    :integer                                # 減価償却
#  amount             :decimal(9, )     default(0), not null  # 原価額
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class TotalCost < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :work, optional: true
  belongs_to :expense, optional: true
  belongs_to :depreciation, optional: true
  belongs_to :total_cost_type

  has_many :total_cost_details, {dependent: :destroy}
end
