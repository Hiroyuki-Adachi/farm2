require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'

class CalendarExcelHalfService
  include Workbook
  MAX_MONTHS = 6

  def self.call(calendar_work_kinds, works, year)
    return new.call(calendar_work_kinds, works, year)
  end

  def call(calendar_work_kinds, works, year)
    workbook = RubyXL::Parser.parse('app/views/calendars/excels/6month01.xlsx')
    setup_workbook(workbook)

    first_month = works[0].model.worked_at.month
    fill_title(workbook[0], calendar_work_kinds, year, first_month)
    fill_holidays(workbook[1], year, 1, 12)
    fill_works(workbook[0], works, first_month)

    return workbook.stream.read
  end

  private

  def fill_title(data_sheet, calendar_work_kinds, year, first_month)
    title_cell = data_sheet[3][0]
    title_cell.change_contents(calendar_work_kinds.map {|calendar_work_kind| calendar_work_kind.work_kind.name }.join('・'))

    data_sheet[5][0].change_contents(year)
    data_sheet[5][2].change_contents(first_month)
  end

  def fill_works(data_sheet, works, first_month)
    works.each do |work|
      break if work.model.worked_at.month - first_month >= MAX_MONTHS
      work_cell = data_sheet[(work.model.worked_at.day * 2) + 4][((work.model.worked_at.month - first_month) * 3) + 2]
      work_cell.change_contents("#{work.exact_work_type_name}(#{work.sum_areas}a)")
    end
  end
end
