require 'test_helper'

class ZgisExcelServiceTest < ActiveSupport::TestCase
  test 'call_place generates expected workbook' do
    land_cost = land_costs(:land_cost_taue)
    work_type = work_types(:work_types1)
    service = ZgisExcelService.new
    data = service.call_place([land_cost], [work_type], 2015)
    workbook = RubyXL::Parser.parse_buffer(data)

    sheet0 = workbook[0]
    assert_equal '作付', sheet0[1][4].value
    assert_equal land_cost.land_id, sheet0[2][1].value
    assert_equal land_cost.land.place, sheet0[2][2].value
    assert_in_delta land_cost.land.area.to_f, sheet0[2][3].value, 0.001
    assert_equal work_type.name, sheet0[2][4].value

    sheet1 = workbook[1]
    assert_equal work_type.name, sheet1[1][0].value
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
    actual_color = actual_color.length >= 6 ? actual_color[-6..] : actual_color
    assert_equal expected_color, actual_color
    assert_equal '255', sheet[0][2].value
  end
end

