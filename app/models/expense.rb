# == Schema Information
#
# Table name: expenses # 経費
#
#  id         :integer          not null, primary key # 経費
#  term       :integer          not null              # 年度(期)
#  payed_on   :date             not null              # 支払日
#  content    :string(40)       not null              # 支払内容
#  amount     :decimal(7, )     default(0), not null  # 支払金額
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Expense < ActiveRecord::Base
  has_many :expense_work_types, {dependent: :delete_all}
  has_many :work_types, {through: :expense_work_types}, -> {order(:display_order)}

  validates :payed_on, presence: true
  validates :content, presence: true
  validates :amount, presence: true

  scope :usual, ->(term){where(term: term).order(payed_on: :ASC, id: :ASC)}
end
