# == Schema Information
#
# Table name: healths
#
#  id            :integer          not null, primary key
#  name          :string(10)       not null
#  code          :string(1)        not null
#  display_order :integer          default("0"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#

require "test_helper"

class HealthTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
