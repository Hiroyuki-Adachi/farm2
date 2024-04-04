require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'

class Calendars::ExcelsController < CalendarsController
  include PermitManager

  MAX_MONTHS = 3

  def index
    excel_data = CalendarExcelMonthService.call(@calendar_work_kinds, @works, @year)

    respond_to do |format|
      format.xlsx do
        send_data excel_data, filename: "calendar.xlsx".encode(Encoding::Windows_31J)
      end
    end
  end
end
