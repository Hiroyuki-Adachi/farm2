# == Schema Information
#
# Table name: lands(土地マスタ)
#
#  id(土地マスタ)                     :integer          not null, primary key
#  area(面積(α))                      :decimal(5, 2)    not null
#  broccoli_mark(ブロッコリ記号)      :string(1)
#  deleted_at                         :datetime
#  display_order(表示順)              :integer
#  end_on(有効期間(至))               :date             default(Tue, 31 Dec 2999), not null
#  group_flag(グループフラグ)         :boolean          default(FALSE), not null
#  group_order(グループ内並び順)      :integer          default(0), not null
#  parcel_number(耕地番号)            :integer
#  peasant_end_term(小作料期間(至))   :integer          default(9999), not null
#  peasant_start_term(小作料期間(自)) :integer          default(0), not null
#  place(番地)                        :string(15)       not null
#  place_sort_key(番地(ソート用))     :string(20)       default(""), not null
#  reg_area(登記面積)                 :decimal(5, 2)
#  region(領域)                       :polygon
#  start_on(有効期間(自))             :date             default(Mon, 01 Jan 1900), not null
#  target_flag(管理対象フラグ)        :boolean          default(TRUE), not null
#  uuid(UUID)                         :string(36)       default(""), not null
#  created_at                         :datetime
#  updated_at                         :datetime
#  group_id(グループID)               :integer
#  land_place_id(土地)                :integer
#  manager_id(管理者)                 :integer
#  owner_id(所有者)                   :integer
#
# Indexes
#
#  index_lands_on_deleted_at      (deleted_at)
#  index_lands_on_place           (place)
#  index_lands_on_place_sort_key  (place_sort_key)
#  index_lands_on_uuid            (uuid) UNIQUE WHERE ((uuid)::text <> ''::text)
#
require 'test_helper'

class LandTest < ActiveSupport::TestCase
  test 'validates place, area and display_order' do
    land = Land.new

    assert_not land.valid?
    assert_not_empty land.errors[:place]
    assert_not_empty land.errors[:area]
    assert_not_empty land.errors[:display_order]

    land.place = '123'
    land.area = 'foo'
    land.display_order = 'bar'
    assert_not land.valid?
    assert_not_empty land.errors[:area]
    assert_not_empty land.errors[:display_order]

    land.area = 10.5
    land.display_order = 1.2
    assert_not land.valid?
    assert_not_empty land.errors[:display_order]

    land.display_order = 1
    assert land.valid?
  end

  test 'costs aggregates days per work type' do
    land = lands(:land_genka2)
    start_date = Date.new(2017, 11, 1)
    end_date = Date.new(2018, 1, 31)

    fee, results = land.costs(start_date, end_date)

    assert_equal land_fees(:land_fee1), fee
    expected_results = {5 => 30, 8 => 62}
    assert_equal(expected_results, results)
  end

  test 'region values and center' do
    land = lands(:lands1)

    expected_region_values = [
      [35.474177, 133.04734],    # Northwest corner
      [35.472866, 133.04734],    # Southwest corner
      [35.472648, 133.049056]    # Southeast corner
    ]
    assert_equal expected_region_values, land.region_values

    center = land.region_center
    assert_in_delta 35.4734125, center[0], 1e-6
    assert_in_delta 133.048198, center[1], 1e-6
  end

  test 'update members' do
    group = lands(:land_group1)
    existing_member = lands(:lands_group1_2)
    new_member = lands(:lands12)

    Land.update_members(group.id, [{land_id: new_member.id, display_order: 2}])

    existing_member.reload
    new_member.reload

    assert_nil existing_member.group_id
    assert_equal 0, existing_member.group_order
    assert_equal group.id, new_member.group_id
    assert_equal 2, new_member.group_order
  end

  test 'expiry?' do
    land = lands(:lands0)

    assert land.expiry?(Date.new(2020, 1, 1))
    assert_not land.expiry?(Date.new(1899, 12, 31))
    assert_not land.expiry?(Date.new(3000, 1, 1))
  end
end

