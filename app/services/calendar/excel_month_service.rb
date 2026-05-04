class Calendar::ExcelMonthService < Calendar::ExcelPeriodService
  TEMPLATE_PATH = 'app/views/calendars/excels/3month01.xlsx'.freeze
  MAX_MONTHS = 3

  private

  def title
    @calendar_work_kinds.first&.work_kind&.name.to_s
  end
end
