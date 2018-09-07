# == Schema Information
#
# Table name: expenses # 経費
#
#  id               :integer          not null, primary key    # 経費
#  term             :integer          not null                 # 年度(期)
#  payed_on         :date             not null                 # 支払日
#  content          :string(40)                                # 支払内容
#  amount           :decimal(7, )     default(0), not null     # 支払金額
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  chemical_type_id :integer          default(0)               # 薬剤種別
#  chemical_id      :integer                                   # 薬剤
#  expense_type_id  :integer          default(0), not null     # 経費種別
#  quantity         :decimal(4, )                              # 数量
#  discount         :decimal(7, )                              # 割引額
#  discount_numor   :decimal(7, )                              # 割引率(分子)
#  discount_denom   :decimal(7, )                              # 割引率(分母)
#  cost_flag        :boolean          default(FALSE), not null # 支払時原価フラグ
#

class Expense < ApplicationRecord

  has_many :expense_work_types, {dependent: :delete_all}
  has_many :work_types, -> {order(:display_order)}, {through: :expense_work_types}
  belongs_to :expense_type
  belongs_to :chemical_type, optional: true
  belongs_to :chemical, optional: true

  validates :payed_on, presence: true
  validates :content, presence: true, unless: :chemical?
  validates :amount, presence: true

  scope :usual, ->(term) {includes(:chemical).where(term: term).order(payed_on: :ASC, id: :ASC)}
  scope :cost, ->(term) {where(term: term, cost_flag: true).order(:id)}
  scope :chemicals, ->(term) {
    joins(:expense_type)
      .where(term: term, cost_flag: false)
      .where("expense_types.chemical_flag = ?", true)
  }

  accepts_nested_attributes_for :expense_work_types, allow_destroy: true

  def discount_amount
    work_amount = amount
    work_amount -= discount if discount.present?
    work_amount -= (amount * discount_numor / discount_denom).round if discount_rate?
    return work_amount
  end

  def discount_rate?
    !discount_numor.to_i.zero? && !discount_denom.to_i.zero?
  end

  def chemical?
    expense_type&.chemical_flag.present?
  end

  def cost_type
    expense_work_types.exists? ? TotalCostType::EXPENSEDIRECT.id : TotalCostType::EXPENSEINDIRECT.id
  end

  def self.chemical_prices(term)
    prices = Hash.new { |h, k| h[k] = {}}
    results = {}
    Expense.chemicals(term).each do |expense|
      prices[expense.chemical_id][:sum_amount] ||= 0
      prices[expense.chemical_id][:sum_quantity] ||= 0
      prices[expense.chemical_id][:sum_amount] += expense.discount_amount
      prices[expense.chemical_id][:sum_quantity] += expense.quantity
    end
    prices.each do |chemical_id, price|
      next if price[:sum_quantity].zero?
      results[chemical_id] ||= (price[:sum_amount] / price[:sum_quantity]).round
    end
    return results
  end
end
