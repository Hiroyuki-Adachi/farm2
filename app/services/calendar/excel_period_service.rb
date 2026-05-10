require 'rubyXL'
require 'rubyXL/convenience_methods'

class Calendar::ExcelPeriodService
  include Workbook

  TITLE_ROW = 3
  YEAR_ROW = 5
  YEAR_COLUMN = 0
  FIRST_MONTH_COLUMN = 2
  WORK_TOP_ROW = 4
  WORK_MONTH_COLUMNS = 3
  WORK_COLUMN_OFFSET = 2

  def self.call(calendar_work_kinds, works, year)
    new(calendar_work_kinds, works, year).call
  end

  def initialize(calendar_work_kinds, works, year)
    @calendar_work_kinds = calendar_work_kinds
    @works = works
    @year = year
  end

  def call
    workbook = parse_workbook(self.class::TEMPLATE_PATH)
    setup_workbook(workbook)

    data_sheet = workbook[0]
    first_month = starting_month

    fill_title(data_sheet, first_month)
    fill_holidays(workbook[1], @year, 1, 12)
    fill_works(data_sheet, first_month)

    workbook.stream.read
  end

  private

  def starting_month
    first_work = @works.first
    return 1 unless first_work

    first_work.model.worked_at.month
  end

  def fill_title(data_sheet, first_month)
    fill_header_title(data_sheet)
    data_sheet[YEAR_ROW][YEAR_COLUMN].change_contents(@year)
    fill_first_month(data_sheet, first_month)
  end

  def fill_header_title(data_sheet)
    data_sheet[TITLE_ROW][0].change_contents(title)
  end

  def fill_first_month(data_sheet, first_month)
    data_sheet[YEAR_ROW][FIRST_MONTH_COLUMN].change_contents(first_month)
  end

  def fill_works(data_sheet, first_month)
    @works.each do |work|
      offset = work.model.worked_at.month - first_month
      next if offset.negative?
      next if offset >= self.class::MAX_MONTHS

      work_cell(data_sheet, work, offset).change_contents(work_label(work))
    end
  end

  def work_cell(data_sheet, work, month_offset)
    row = (work.model.worked_at.day * 2) + WORK_TOP_ROW
    column = (month_offset * WORK_MONTH_COLUMNS) + WORK_COLUMN_OFFSET
    data_sheet[row][column]
  end

  def work_label(work)
    "#{work.exact_work_type_name}(#{work.sum_areas}a)"
  end

  def title
    raise NotImplementedError
  end
end
