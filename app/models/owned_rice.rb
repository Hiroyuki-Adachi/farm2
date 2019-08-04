# == Schema Information
#
# Table name: owned_rices # 保有米
#
#  id                  :bigint           not null, primary key
#  home_id             :integer          default(0), not null  # 購入世帯
#  owned_rice_price_id :integer          default(0), not null  # 保有米単価
#  owned_count         :decimal(3, )     default(0), not null  # 保有米数
#  relative_count      :decimal(3, )     default(0), not null  # 縁故米数
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class OwnedRice < ApplicationRecord
  belongs_to :owned_rice_price
  belongs_to :home

  scope :usual, ->(term) {
    joins(:owned_rice_price)
      .where(["owned_rice_prices.term = ?", term])
  }

  scope :by_home, ->(term, home_id) {
    joins(:owned_rice_price)
      .where(["owned_rice_prices.term = ? AND owned_rices.home_id = ?", term, home_id])
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
end
