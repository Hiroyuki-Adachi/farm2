require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'

class Calendars::ExcelsController < CalendarsController
  include PermitManager

  def index
    excel_data = case params[:months]
                 when "3"
                   CalendarExcelMonthService.call(@calendar_work_kinds, @works, @year)
                 when "6"
                   CalendarExcelHalfService.call(@calendar_work_kinds, @works, @year)
                 when "12"
                   CalendarExcelYearService.call(@works, @year)
                 end

    send_data excel_data, filename: "calendar.xlsx".encode(Encoding::Windows_31J)
  end
end
