class CalendarsController < ApplicationController
  include PermitManager

  before_action :set_works, only: [:index]

  def index
    @weathers = DailyWeather.usual(@year).to_a
  end

  protected

  def set_works
    @year = current_user.calendar_term
    @calendar_work_kinds = CalendarWorkKind.usual(current_user).to_a
    @work_kind_ids = @calendar_work_kinds.map(&:work_kind_id)
    @schedules = Schedule.for_calendar(@year, @work_kind_ids)
    @works = Work.for_calendar(@year, @work_kind_ids - @schedules.map(&:work_kind_id))
    @works = WorkDecorator.decorate_collection(@works)
  end
end
