# == Schema Information
#
# Table name: expenses
#
#  id(経費)                     :integer          not null, primary key
#  amount(支払金額)             :decimal(7, )     default(0), not null
#  content(支払内容)            :string(40)
#  cost_flag(支払時原価フラグ)  :boolean          default(FALSE), not null
#  discount(割引額)             :decimal(7, )
#  discount_denom(割引率(分母)) :decimal(7, )
#  discount_numor(割引率(分子)) :decimal(7, )
#  payed_on(支払日)             :date             not null
#  quantity(数量)               :decimal(4, )
#  term(年度(期))               :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  chemical_id(薬剤)            :integer
#  chemical_type_id(薬剤種別)   :integer          default(0)
#  expense_type_id(経費種別)    :integer          default(0), not null
#

class Expense < ApplicationRecord
  has_many :expense_work_types, dependent: :destroy
  has_many :work_types, -> {order(:display_order)}, through: :expense_work_types
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
      .where(expense_types: { chemical_flag: true })
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

  def direct?
    expense_work_types.exists?
  end

  def cost_type
    direct? ? TotalCostType::EXPENSEDIRECT.id : TotalCostType::EXPENSEINDIRECT.id
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
