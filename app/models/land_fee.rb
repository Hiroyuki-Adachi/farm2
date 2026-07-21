# == Schema Information
#
# Table name: land_fees(土地料金)
#
#  id                  :bigint           not null, primary key
#  manage_fee(管理料)  :decimal(7, 1)    default(0.0), not null
#  peasant_fee(小作料) :decimal(7, 1)    default(0.0), not null
#  term(年度(期))      :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  land_id(土地)       :integer          not null
#
# Indexes
#
#  land_fees_2nd  (term,land_id) UNIQUE
#

class LandFee < ApplicationRecord
  belongs_to :land

  scope :for_organization, ->(organization) { joins(:land).merge(Land.for_organization(organization)) }

  def self.save_all_from_params(organization, home_id, params)
    lands = Land.for_organization(organization).where(owner_id: home_id)

    params.each_value do |attributes|
      land = lands.find(attributes[:land_id])
      fee = attributes[:id].present? ? for_organization(organization).find(attributes[:id]) : new

      fee.assign_attributes(attributes.except(:id, :land_id))
      fee.land = land
      fee.save!
    end
  end
end
