# == Schema Information
#
# Table name: work_whole_crops
#
#  id           :integer          not null, primary key
#  work_id      :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  unit_price   :decimal(5, 2)    default("0"), not null
#  tax_rate     :decimal(3, 1)    default("0"), not null
#  article_name :string(15)       default(""), not null
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
    assert_equal 50 * 15, @work_wcs.whole_crop.roll_price
    assert_equal 50 * 15 * 45, @work_wcs.whole_crop.price
    assert_equal (50 * 15 * 45 * 0.08).floor(0), @work_wcs.whole_crop.tax_amount
    assert_equal (50 * 15 * 45 * 1.08).floor(0), @work_wcs.whole_crop.amount
  end
end
