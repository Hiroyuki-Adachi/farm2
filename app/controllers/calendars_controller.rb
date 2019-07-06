class CalendarsController < ApplicationController
  include PermitManager

  def index
    @year = current_user.calendar_term
    @calendar_work_kinds = CalendarWorkKind.usual(current_user).to_a
    @works = Work.for_calendar(@year, @calendar_work_kinds.map(&:work_kind_id)).to_a
  end
end
