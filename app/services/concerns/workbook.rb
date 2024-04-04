module Workbook
  HOLIDAY_TOP_ROW = 3

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
end
