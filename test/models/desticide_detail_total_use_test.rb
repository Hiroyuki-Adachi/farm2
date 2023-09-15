# == Schema Information
#
# Table name: desticide_detail_total_uses
#
#  id                     :bigint           not null, primary key
#  no(有効成分番号)       :integer          not null
#  total_uses(総使用回数) :string(50)       not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  desticide_id(登録番号) :integer          not null
#
require "test_helper"

class DesticideDetailTotalUseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
