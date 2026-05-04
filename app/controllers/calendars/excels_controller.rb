class Calendars::ExcelsController < CalendarsController
  include PermitManager

  def index
    excel_data = build_excel_data
    return head :bad_request unless excel_data

    send_data excel_data, filename: "calendar.xlsx".encode(Encoding::Windows_31J)
  end

  private

  def build_excel_data
    case params[:months]
    when "3"
      Calendar::ExcelMonthService.call(@calendar_work_kinds, @works, @year)
    when "6"
      Calendar::ExcelHalfService.call(@calendar_work_kinds, @works, @year)
    when "12"
      Calendar::ExcelYearService.call(@works, @year)
    end
  end
end
