require 'test_helper'
require 'ostruct'

class CalendarExcelMonthServiceTest < ActiveSupport::TestCase
  test 'call generates expected workbook' do
    calendar_work_kind = OpenStruct.new(work_kind: work_kinds(:work_kind_taue))
    work_date = Date.new(2023, 1, 15)
    work_model = OpenStruct.new(worked_at: work_date)
    work = OpenStruct.new(model: work_model,
                          exact_work_type_name: '代掻',
                          sum_areas: 10)

    excel = CalendarExcelMonthService.call([calendar_work_kind], [work], work_date.year)
    workbook = RubyXL::Parser.parse_buffer(excel)
    sheet = workbook[0]

    assert_equal work_kinds(:work_kind_taue).name, sheet[3][0].value
    assert_equal work_date.year, sheet[5][0].value
    assert_equal work_date.month, sheet[5][2].value
    expected_row = calculate_work_entry_row(work_date.day)
    assert_equal '代掻(10a)', sheet[expected_row][2].value
  end
end

