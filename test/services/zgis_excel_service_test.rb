require 'test_helper'

class ZgisExcelServiceTest < ActiveSupport::TestCase
  test 'call_place generates expected workbook' do
    land_cost = land_costs(:cost1)
    work_type = land_cost.work_type
    service = ZgisExcelService.new
    data = service.call_place([land_cost], [work_type], 2015)
    workbook = RubyXL::Parser.parse_buffer(data)

    sheet0 = workbook[0]
    assert_equal ['ID', '耕地番号', '番地', '面積', '作付'], sheet0[1].cells[1..5].map(&:value)
    assert_equal land_cost.land_id, sheet0[2][1].value
    assert_equal 12_341_234, sheet0[2][2].value
    assert_equal land_cost.land.place, sheet0[2][3].value
    assert_in_delta land_cost.land.area.to_f, sheet0[2][4].value, 0.001
    assert_equal work_type.name, sheet0[2][5].value

    sheet1 = workbook[1]
    assert_equal work_type.name, sheet1[1][0].value
  end

  test 'call_place keeps columns aligned for multiple lands including a missing parcel number' do
    land_costs = [land_costs(:land_cost_taue), land_costs(:cost1)]
    assert_nil land_costs.first.land.parcel_number

    data = ZgisExcelService.new.call_place(land_costs, nil, nil)
    sheet = RubyXL::Parser.parse_buffer(data)[0]

    land_costs.each_with_index do |land_cost, index|
      expected = [land_cost.land_id, land_cost.land.parcel_number, land_cost.land.place,
                  land_cost.land.area.to_f, land_cost.work_type.name]
      assert_equal expected, sheet[index + 2].cells[1..5].map(&:value)
    end
  end

  test 'call_place exports polygon coordinates in longitude latitude order' do
    land_cost = land_costs(:cost1)
    land_cost.land.region = '((35.4,133.0),(35.5,133.1),(35.4,133.0))'

    data = ZgisExcelService.new.call_place([land_cost], nil, nil)
    sheet = RubyXL::Parser.parse_buffer(data)[0]

    assert_equal 'Polygon((133.0 35.4,133.1 35.5,133.0 35.4))', sheet[2][0].value
  end

  test 'call_place leaves polygon blank when land has no region' do
    land_cost = land_costs(:cost1)
    land_cost.land.region = nil

    data = ZgisExcelService.new.call_place([land_cost], nil, nil)
    sheet = RubyXL::Parser.parse_buffer(data)[0]

    assert sheet[2][0].value.blank?
    assert_equal 12_341_234, sheet[2][2].value
  end

  test 'call_place supports an empty land list' do
    data = ZgisExcelService.new.call_place([], nil, nil)
    sheet = RubyXL::Parser.parse_buffer(data)[0]

    assert_equal ['ID', '耕地番号', '番地', '面積', '作付'], sheet[1].cells[1..5].map(&:value)
    assert_nil sheet[2]
  end

  test 'call packages places and colors workbooks in a zip' do
    land_cost = land_costs(:cost1)
    work_type = land_cost.work_type
    path = ZgisExcelService.call([land_cost], [work_type], 2015)

    Zip::File.open(path) do |zip|
      assert_equal ['zgis-colors.xlsx', 'zgis-places.xlsx'], zip.entries.map(&:name).sort
      places = RubyXL::Parser.parse_buffer(zip.read('zgis-places.xlsx'))
      assert_equal '耕地番号', places[0][1][2].value
      assert_equal 12_341_234, places[0][2][2].value
      assert_equal work_type.name, places[0][2][5].value
      assert_equal work_type.name, places[1][1][0].value

      colors = RubyXL::Parser.parse_buffer(zip.read('zgis-colors.xlsx'))
      assert_equal work_type.name, colors[0][0][0].value
    end
  ensure
    File.delete(path) if path && File.exist?(path)
  end

  test 'call_color generates work type colors' do
    work_type = work_types(:work_type_koshi)
    service = ZgisExcelService.new
    data = service.call_color([work_type], 2015)
    workbook = RubyXL::Parser.parse_buffer(data)
    sheet = workbook[0]

    assert_equal work_type.name, sheet[0][0].value
    expected_color = work_type.bg_color.delete('#').downcase
    actual_color = sheet[0][1].fill_color.to_s.delete('#').downcase
    # Compare only the last 6 characters if actual_color is at least 6 chars, else use the whole string
    actual_color = actual_color[-6..] if actual_color.length >= 6
    assert_equal expected_color, actual_color
    assert_equal '255', sheet[0][2].value
  end
end
