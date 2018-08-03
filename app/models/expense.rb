# == Schema Information
#
# Table name: expenses # 経費
#
#  id               :integer          not null, primary key # 経費
#  term             :integer          not null              # 年度(期)
#  payed_on         :date             not null              # 支払日
#  content          :string(40)       not null              # 支払内容
#  amount           :decimal(7, )     default(0), not null  # 支払金額
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  chemical_type_id :integer          default(0), not null  # 薬剤種別
#  chemical_id      :integer                                # 薬剤
#  expense_type_id  :integer          default(0), not null  # 経費種別
#

class Expense < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  has_many :expense_work_types, {dependent: :delete_all}
  has_many :work_types, -> {order(:display_order)}, {through: :expense_work_types}
  belongs_to :expense_type

  validates :payed_on, presence: true
  validates :content, presence: true
  validates :amount, presence: true

  scope :usual, ->(term){where(term: term).order(payed_on: :ASC, id: :ASC)}

  accepts_nested_attributes_for :expense_work_types, allow_destroy: true
end
