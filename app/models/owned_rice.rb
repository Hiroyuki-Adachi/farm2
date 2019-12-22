# == Schema Information
#
# Table name: owned_rices # 保有米
#
#  id                  :bigint           not null, primary key
#  home_id             :integer          default(0), not null  # 購入世帯
#  owned_rice_price_id :integer          default(0), not null  # 保有米単価
#  owned_count         :decimal(3, )     default(0), not null  # 保有米数
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class OwnedRice < ApplicationRecord
  belongs_to :owned_rice_price
  belongs_to :home

  OWNED_RICE_COUNT = 2 # 10a当たりの保有米数

  scope :usual, ->(term) {
    joins(:owned_rice_price)
      .where(["owned_rice_prices.term = ?", term])
  }

  scope :by_home, ->(term, home_id) {
    joins(:owned_rice_price)
      .where(["owned_rice_prices.term = ? AND owned_rices.home_id = ?", term, home_id])
      .order("owned_rice_prices.display_order, owned_rice_prices.id")
  }

  scope :available, -> {where("owned_rices.owned_count > 0")}

  scope :for_finance, ->(term) {
    joins(:owned_rice_price)
      .joins(:home)
      .where(["owned_rice_prices.term = ?", term])
      .where("owned_rices.owned_count > 0")
      .order("homes.finance_order, homes.id, owned_rice_prices.display_order, owned_rice_prices.id")
  }

  def sum_count
    owned_count + relative_count
  end

  def self.regist(id, params)
    owned_rice = OwnedRice.find_by(id: id) if id
    if owned_rice
      owned_rice.update(params)
    else
      OwnedRice.create(params)
    end
  end

  def owned_price
    owned_count * owned_rice_price.owned_price
  end
end
