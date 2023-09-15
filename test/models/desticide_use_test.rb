# == Schema Information
#
# Table name: desticide_uses
#
#  id             :bigint           not null, primary key
#  name(使用方法) :string(50)       not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
require "test_helper"

class DesticideUseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
