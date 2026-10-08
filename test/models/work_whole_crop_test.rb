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

  test "事前読み込みした収穫の集計と判定ではSQLを発行しない" do
    crop = WorkWholeCrop.includes(:wcs_lands, :wcs_rolls).find(work_whole_crops(:whole_crop1).id)
    queries = []
    subscriber = ->(*args) { queries << args.last[:sql] unless args.last[:name] == 'SCHEMA' }

    ActiveSupport::Notifications.subscribed(subscriber, 'sql.active_record') do
      assert_equal 45, crop.rolls
      assert_equal 50.8, crop.weight
      assert crop.harvested?
      assert_equal 51 * 15 * 45, crop.price
    end
    assert_empty queries
  end

  test "事前読み込みでも数量ゼロと重量ゼロを警告判定する" do
    crop = work_whole_crops(:whole_crop1)
    crop.wcs_lands.each { |land| land.update!(rolls: 0) }
    loaded_crop = WorkWholeCrop.includes(:wcs_lands, :wcs_rolls).find(crop.id)
    assert_equal crop.weight, loaded_crop.weight
    assert_equal 0, loaded_crop.rolls
    assert_not loaded_crop.harvested?

    crop.wcs_lands.each { |land| land.update!(rolls: 1) }
    crop.wcs_rolls.each { |roll| roll.update!(weight: 0) }
    loaded_crop = WorkWholeCrop.includes(:wcs_lands, :wcs_rolls).find(crop.id)
    assert_equal 2, loaded_crop.rolls
    assert_equal 0, loaded_crop.weight
    assert_not loaded_crop.harvested?
  end
end
