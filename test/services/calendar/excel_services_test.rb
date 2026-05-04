require 'test_helper'

class Calendar::ExcelServicesTest < ActiveSupport::TestCase
  include Workbook

  CalendarWorkKindDouble = Struct.new(:work_kind, keyword_init: true)
  WorkModelDouble = Struct.new(:worked_at, keyword_init: true)
  WorkDouble = Struct.new(:model, :work_kind, :exact_work_type_name, :sum_areas, keyword_init: true)

  test 'call generates expected workbook' do
    calendar_work_kind = build_calendar_work_kind(work_kinds(:work_kind_taue))
    work_date = Date.new(2023, 1, 15)
    work = build_work(work_date, exact_work_type_name: '代掻', sum_areas: 10)

    excel = Calendar::ExcelMonthService.call([calendar_work_kind], [work], work_date.year)
    workbook = parse_workbook_buffer(excel)
    sheet = workbook[0]

    assert_equal work_kinds(:work_kind_taue).name, sheet[3][0].value
    assert_equal work_date.year, sheet[5][0].value
    assert_equal work_date.month, sheet[5][2].value
    assert_equal '代掻(10a)', sheet[(work_date.day * 2) + 4][2].value
  end

  test 'month workbook can be generated without works' do
    calendar_work_kind = build_calendar_work_kind(work_kinds(:work_kind_taue))

    excel = Calendar::ExcelMonthService.call([calendar_work_kind], [], 2023)
    workbook = parse_workbook_buffer(excel)
    sheet = workbook[0]

    assert_equal work_kinds(:work_kind_taue).name, sheet[3][0].value
    assert_equal 2023, sheet[5][0].value
    assert_equal 1, sheet[5][2].value
  end

  test 'half workbook joins work kind names and ignores works after six months' do
    calendar_work_kinds = [
      build_calendar_work_kind(work_kinds(:work_kind_taue)),
      build_calendar_work_kind(work_kinds(:work_kind_shirokaki))
    ]
    first_work = build_work(Date.new(2023, 1, 5), exact_work_type_name: '代掻', sum_areas: 10)
    seventh_month_work = build_work(Date.new(2023, 7, 5), exact_work_type_name: '除草', sum_areas: 20)

    excel = Calendar::ExcelHalfService.call(calendar_work_kinds, [first_work, seventh_month_work], 2023)
    workbook = parse_workbook_buffer(excel)
    sheet = workbook[0]

    assert_equal calendar_work_kinds.map { |calendar_work_kind| calendar_work_kind.work_kind.name }.join('・'), sheet[3][0].value
    assert_equal '代掻(10a)', sheet[(first_work.model.worked_at.day * 2) + 4][2].value
    assert_nil sheet[(seventh_month_work.model.worked_at.day * 2) + 4][20]&.value
  end

  test 'year workbook includes work kind name in work label' do
    work_date = Date.new(2023, 4, 10)
    work = build_work(
      work_date,
      work_kind: work_kinds(:work_kind_taue),
      exact_work_type_name: '田植',
      sum_areas: 15
    )

    excel = Calendar::ExcelYearService.call([work], 2023)
    workbook = parse_workbook_buffer(excel)
    sheet = workbook[0]

    assert_equal 2023, sheet[5][0].value
    assert_equal "#{work_kinds(:work_kind_taue).name}(田植:15a)", sheet[(work_date.day * 2) + 4][11].value
  end

  private

  def build_calendar_work_kind(work_kind)
    CalendarWorkKindDouble.new(work_kind: work_kind)
  end

  def build_work(worked_at, exact_work_type_name:, sum_areas:, work_kind: nil)
    WorkDouble.new(
      model: WorkModelDouble.new(worked_at: worked_at),
      work_kind: work_kind,
      exact_work_type_name: exact_work_type_name,
      sum_areas: sum_areas
    )
  end
end
