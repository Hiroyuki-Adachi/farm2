class Calendar::ExcelHalfService < Calendar::ExcelPeriodService
  TEMPLATE_PATH = 'app/views/calendars/excels/6month01.xlsx'.freeze
  MAX_MONTHS = 6

  private

  def title
    @calendar_work_kinds.map { |calendar_work_kind| calendar_work_kind.work_kind.name }.join('・')
  end
end
