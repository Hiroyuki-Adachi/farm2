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
    assert_equal({5 => 30, 8 => 62}, results)
  end

  test 'region values and center' do
    land = lands(:lands1)

    assert_equal [[35.474177, 133.04734], [35.472866, 133.04734], [35.472648, 133.049056]], land.region_values

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

