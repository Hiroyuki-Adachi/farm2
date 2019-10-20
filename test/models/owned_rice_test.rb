# == Schema Information
#
# Table name: owned_rices # 保有米
#
#  id                  :bigint           not null, primary key
#  home_id             :integer          default(0), not null  # 購入世帯
#  owned_rice_price_id :integer          default(0), not null  # 保有米単価
#  owned_count         :decimal(3, )     default(0), not null  # 保有米数
#  relative_count      :decimal(3, )     default(0), not null  # 縁故米数
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

require 'test_helper'

class OwnedRiceTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
