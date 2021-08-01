require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'

class Calendars::YearExcelsController < CalendarsController
  include PermitManager

  def index
    workbook = RubyXL::Parser.parse('app/views/calendars/excels/year02.xlsx')

    workbook.calc_pr.full_calc_on_load = true
    workbook.calc_pr.calc_completed = true
    workbook.calc_pr.calc_on_save = true
    workbook.calc_pr.force_full_calc = true

    data_sheet = workbook[0]

    data_sheet[5][0].change_contents(@works[0].model.worked_at.year)

    holiday_row = 3
    holiday_sheet = workbook[1]
    (Date.new(@year, 1, 1)..Date.new(@year, 12, 31)).each do |today|
      if HolidayJp.holiday?(today)
        holiday_sheet[holiday_row][0].change_contents(today.month)
        holiday_sheet[holiday_row][1].change_contents(today.day)
        holiday_sheet[holiday_row][4].change_contents(HolidayJp.between(today, today).first.name)
        holiday_sheet[holiday_row][5].change_contents("休日")
        holiday_row += 1
      end
    end

    @works.each do |work|
      work_cell = data_sheet[work.model.worked_at.day * 2 + 4][(work.model.worked_at.month - 1) * 3 + 2]
      work_cell.change_contents("#{work.work_kind.name}(#{work.exact_work_type_name}:#{work.sum_areas}a)")
    end

    respond_to do |format|
      format.xlsx do
       send_data workbook.stream.read, filename: "calendar.xlsx".encode(Encoding::Windows_31J)
      end
    end
  ensure
    workbook.stream.close  # streamを閉じる
  end
end
