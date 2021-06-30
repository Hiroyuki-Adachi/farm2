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
require "test_helper"

class LandFeeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
