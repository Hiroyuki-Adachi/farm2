# == Schema Information
#
# Table name: land_fees
#
#  id          :integer          not null, primary key
#  term        :integer          not null
#  land_id     :integer          not null
#  manage_fee  :decimal(7, 1)    default("0.0"), not null
#  peasant_fee :decimal(7, 1)    default("0.0"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  land_fees_2nd  (term,land_id) UNIQUE
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
