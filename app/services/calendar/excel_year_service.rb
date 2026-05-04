class Calendar::ExcelYearService < Calendar::ExcelPeriodService
  TEMPLATE_PATH = 'app/views/calendars/excels/year02.xlsx'.freeze
  MAX_MONTHS = 12

  def self.call(works, year)
    new([], works, year).call
  end

  private

  def starting_month
    1
  end

  def fill_header_title(_data_sheet)
    nil
  end

  def fill_first_month(_data_sheet, _first_month)
    nil
  end

  def work_label(work)
    "#{work.work_kind.name}(#{work.exact_work_type_name}:#{work.sum_areas}a)"
  end
end
