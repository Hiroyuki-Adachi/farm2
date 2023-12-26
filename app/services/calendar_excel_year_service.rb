require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'

class CalendarExcelYearService
  include Workbook

  def self.call(works, year)
    return new.call(works, year)
  end
    
  def call(works, year)
    workbook = RubyXL::Parser.parse('app/views/calendars/excels/year02.xlsx')
    setup_workbook(workbook)

    fill_title(workbook[0], year)
    fill_holidays(workbook[1], year, 1, 12)
    fill_works(workbook[0], works)

    return workbook.stream.read
  end

  private

  def fill_title(data_sheet, year)
    data_sheet[5][0].change_contents(year)
  end

  def fill_works(data_sheet, works)
    works.each do |work|
      work_cell = data_sheet[work.model.worked_at.day * 2 + 4][(work.model.worked_at.month - 1) * 3 + 2]
      work_cell.change_contents("#{work.work_kind.name}(#{work.exact_work_type_name}:#{work.sum_areas}a)")
    end
  end
end
