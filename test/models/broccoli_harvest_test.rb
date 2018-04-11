# == Schema Information
#
# Table name: broccoli_harvests # ブロッコリー収穫
#
#  id               :integer          not null, primary key # ブロッコリー収穫
#  work_broccoli_id :integer          not null              # ブロッコリー作業
#  broccoli_rank_id :integer          not null              # ブロッコリー等級
#  broccoli_size_id :integer          not null              # ブロッコリー階級
#  inspection       :decimal(3, )     default(0), not null  # 検査後数量
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class BroccoliHarvestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
