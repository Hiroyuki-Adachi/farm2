# == Schema Information
#
# Table name: work_whole_crops(WCS作業)
#
#  id                   :bigint           not null, primary key
#  article_name(品名)   :string(15)       default(""), not null
#  tax_rate(消費税率)   :decimal(3, 1)    default(0.0), not null
#  unit_price(標準単価) :decimal(5, 2)    default(0.0), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  work_id(作業)        :integer          not null
#
# Indexes
#
#  index_work_whole_crops_on_work_id  (work_id) UNIQUE
#

require 'test_helper'

class WorkWholeCropTest < ActiveSupport::TestCase
  setup do
    @work = works(:work_for_price)
    @work_wcs = works(:work_wcs2)
  end

  test "WCSでない場合" do
    assert_nil @work.whole_crop
  end

  test "WCSの場合" do
    assert_not_nil @work_wcs.whole_crop
    assert_equal 45, @work_wcs.whole_crop.rolls
    assert_equal 50.8, @work_wcs.whole_crop.weight
    assert_equal 51 * 15 * 45, @work_wcs.whole_crop.price
  end
end
