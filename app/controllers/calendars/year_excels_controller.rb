require 'rubyXL'
require 'rubyXL/convenience_methods/cell'
require 'rubyXL/convenience_methods/workbook'

class Calendars::YearExcelsController < CalendarsController
  include PermitManager

  def index
    excel_data = CalendarExcelYearService.call(@works, @year)

    respond_to do |format|
      format.xlsx do
        send_data excel_data, filename: "calendar.xlsx".encode(Encoding::Windows_31J)
      end
    end
  end
end
