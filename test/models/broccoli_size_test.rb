# == Schema Information
#
# Table name: broccoli_sizes # ブロッコリ階級マスタ
#
#  id            :integer          not null, primary key # ブロッコリ階級マスタ
#  display_name  :string(10)       default(""), not null # 表示名
#  display_order :integer          default(0), not null  # 表示順
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class BroccoliSizeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end