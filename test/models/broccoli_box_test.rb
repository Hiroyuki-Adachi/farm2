# == Schema Information
#
# Table name: broccoli_boxes # ブロッコリ箱マスタ
#
#  id            :integer          not null, primary key  # ブロッコリ箱マスタ
#  weight        :decimal(3, 1)    default(0.0), not null # 重さ(kg)
#  display_name  :string(10)       default(""), not null  # 表示名
#  display_order :integer          default(0), not null   # 表示順
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class BroccoliBoxTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
