# == Schema Information
#
# Table name: desticide_crops
#
#  id           :bigint           not null, primary key
#  name(作物名) :string(50)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "test_helper"

class DesticideCropTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
