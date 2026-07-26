# == Schema Information
#
# Table name: owned_rices(保有米)
#
#  id                              :bigint           not null, primary key
#  owned_count(保有米数)           :decimal(3, )     default(0), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  home_id(購入世帯)               :integer          default(0), not null
#  owned_rice_price_id(保有米単価) :integer          default(0), not null
#
# Indexes
#
#  owned_rices_2nd  (home_id,owned_rice_price_id) UNIQUE
#

class OwnedRice < ApplicationRecord
  belongs_to :owned_rice_price
  belongs_to :home

  OWNED_RICE_COUNT = 2 # 10a当たりの保有米数

  scope :for_organization, ->(organization) { joins(:home).merge(Home.for_organization(organization)) }

  scope :usual, lambda { |term, organization = nil|
    base = joins(:owned_rice_price)
      .where(owned_rice_prices: { term: term })
    organization ? base.for_organization(organization) : base
  }

  scope :by_home, lambda { |term, home_id, organization = nil|
    base = joins(:owned_rice_price)
      .where(["owned_rice_prices.term = ? AND owned_rices.home_id = ?", term, home_id])
      .order("owned_rice_prices.display_order, owned_rice_prices.id")
    organization ? base.for_organization(organization) : base
  }

  scope :available, -> { where("owned_rices.owned_count > 0") }

  scope :for_finance, lambda { |term, organization = nil|
    base = joins(:owned_rice_price)
      .joins(:home)
      .where(owned_rice_prices: { term: term })
      .where("owned_rices.owned_count > 0")
      .order("homes.finance_order, homes.id, owned_rice_prices.display_order, owned_rice_prices.id")
    organization ? base.for_organization(organization) : base
  }

  def self.regist(id, params, organization = nil)
    home = organization ? Home.for_organization(organization).find(params[:home_id]) : Home.find(params[:home_id])
    owned_rice = if id.present? && organization
                   for_organization(organization).find(id)
                 elsif id.present?
                   OwnedRice.find_by(id: id)
                 end
    attributes = params.except(:home_id).merge(home: home)
    owned_rice ? owned_rice.update(attributes) : create(attributes)
  end

  def owned_price
    owned_count * owned_rice_price.owned_price
  end
end
