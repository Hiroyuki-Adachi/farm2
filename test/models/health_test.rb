# == Schema Information
#
# Table name: healths
#
#  id                    :bigint           not null, primary key
#  code(コード)          :string(1)        not null
#  deleted_at            :datetime
#  display_order(表示順) :integer          default(0), not null
#  name(原価種別名称)    :string(10)       not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

require "test_helper"

class HealthTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
