# == Schema Information
#
# Table name: work_broccolis # ブロッコリー作業
#
#  id              :integer          not null, primary key # ブロッコリー作業
#  work_id         :integer          not null              # 作業
#  broccoli_box_id :integer          not null              # 箱
#  shipped_on      :date             not null              # 出荷日
#  rest            :decimal(3, )     default(0), not null  # 残数
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'test_helper'

class WorkBroccoliTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
