require 'rubyXL'
require 'rubyXL/convenience_methods'

class Calendar::ExcelYearService
  include Workbook

  TEMPLATE_PATH = 'app/views/calendars/excels/year02.xlsx'.freeze
  YEAR_ROW = 5
  YEAR_COLUMN = 0
  WORK_TOP_ROW = 4
  WORK_MONTH_COLUMNS = 3
  WORK_COLUMN_OFFSET = 2

  def self.call(works, year)
    new(works, year).call
  end

  def initialize(works, year)
    @works = works
    @year = year
  end

  def call
    workbook = parse_workbook(TEMPLATE_PATH)
    setup_workbook(workbook)

    fill_title(workbook[0])
    fill_holidays(workbook[1], year, 1, 12)
    fill_works(workbook[0], works)

    workbook.stream.read
  end

  private

  attr_reader :works, :year

  def fill_title(data_sheet)
    data_sheet[YEAR_ROW][YEAR_COLUMN].change_contents(year)
  end

  def fill_works(data_sheet, works)
    works.each do |work|
      work_cell = work_cell(data_sheet, work)
      work_cell.change_contents("#{work.work_kind.name}(#{work.exact_work_type_name}:#{work.sum_areas}a)")
    end
  end

  def work_cell(data_sheet, work)
    row = (work.model.worked_at.day * 2) + WORK_TOP_ROW
    column = ((work.model.worked_at.month - 1) * WORK_MONTH_COLUMNS) + WORK_COLUMN_OFFSET
    data_sheet[row][column]
  end
end
