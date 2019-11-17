class CalendarsController < ApplicationController
  include PermitManager

  def index
    @year = current_user.calendar_term
    @calendar_work_kinds = CalendarWorkKind.usual(current_user).to_a
    @work_kind_ids = @calendar_work_kinds.map(&:work_kind_id)
    @schedules = Schedule.for_calendar(@year, @work_kind_ids)
    @weathers = DailyWeather.usual(@year).to_a
    @works = WorkDecorator.decorate_collection(Work.for_calendar(@year, @work_kind_ids - @schedules.map(&:work_kind_id)))
  end
end
