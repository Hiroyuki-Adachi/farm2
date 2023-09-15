# == Schema Information
#
# Table name: desticide_pest_weeds
#
#  id                     :bigint           not null, primary key
#  name(適用病害虫雑草名) :string(50)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
require "test_helper"

class DesticidePestWeedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
