# == Schema Information
#
# Table name: rice_types # 品種(米)
#
#  id            :bigint           not null, primary key
#  name          :string(10)       default(""), not null # 品種名
#  display_order :integer          default(0), not null  # 表示順
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class RiceTypeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
