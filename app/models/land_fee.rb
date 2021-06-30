# == Schema Information
#
# Table name: land_fees
#
#  id                  :bigint           not null, primary key
#  manage_fee(管理料)  :decimal(7, 1)    default(0.0), not null
#  peasant_fee(小作料) :decimal(7, 1)    default(0.0), not null
#  term(年度(期))      :integer          not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  land_id(土地)       :integer          not null
#
class LandFee < ApplicationRecord
  belongs_to :land

  def self.upsert(home_id, params)
    params.each do |param|
      fee = LandFee.find_by(id: param[1][:id])
      if fee
        fee.update(param[1])
      else
        LandFee.create(param[1])
      end
    end
  end
end
