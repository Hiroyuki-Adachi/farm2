module Workbook
  HOLIDAY_TOP_ROW = 3
  RUBYXL_WARNING_MUTEX = Mutex.new

  def setup_workbook(workbook)
    workbook.calc_pr.full_calc_on_load = true
    workbook.calc_pr.calc_completed = true
    workbook.calc_pr.calc_on_save = true
    workbook.calc_pr.force_full_calc = true
  end

  def fill_holidays(holiday_sheet, year, first_month, last_month)
    holiday_row = HOLIDAY_TOP_ROW
    (Date.new(year, first_month, 1)..Date.new(year, last_month, -1)).each do |today|
      next unless HolidayJp.holiday?(today)
      holiday_sheet[holiday_row][0].change_contents(today.month)
      holiday_sheet[holiday_row][1].change_contents(today.day)
      holiday_sheet[holiday_row][4].change_contents(HolidayJp.between(today, today).first.name)
      holiday_sheet[holiday_row][5].change_contents("休日")
      holiday_row += 1
    end
  end

  def parse_workbook(path)
    with_suppressed_rubyxl_warnings { RubyXL::Parser.parse(path) }
  end

  def parse_workbook_buffer(data)
    with_suppressed_rubyxl_warnings { RubyXL::Parser.parse_buffer(data) }
  end

  private

  # rubocop:disable Style/ClassVars
  def with_suppressed_rubyxl_warnings
    RUBYXL_WARNING_MUTEX.synchronize do
      previous = RubyXL.class_variable_get(:@@suppress_warnings)
      RubyXL.class_variable_set(:@@suppress_warnings, true)
      yield
    ensure
      RubyXL.class_variable_set(:@@suppress_warnings, previous)
    end
  end
  # rubocop:enable Style/ClassVars
end
