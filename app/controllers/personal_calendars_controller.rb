class PersonalCalendarsController < ApplicationController
  def show
    @worker = Worker.find_by(token: params[:token])
    if @worker
      @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_calendar(@worker))
      @results = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from))
      @company = Worker.company.first
      calendar = make_calendar
      calendar.publish
      headers["Content-Type"] = "text/calendar; charset=UTF-8"
      render plain: calendar.to_ical
    else
      to_error_path
    end
  end

  private

  def restrict_remote_ip
  end

  def worked_from
    Date.new(Date.today.year - 1, 1, 1)
  end

  def make_calendar
    calendar = create_calendar
    @results.each do |result|
      calendar.add_event(make_event_for_work(result))
    end
    @schedules.each do |schedule|
      calendar.add_event(make_event_for_schedule(schedule))
    end
    return calendar
  end

  def make_event_for_work(result)
    work = result.work.model
    event = ::Icalendar::Event.new
    event.summary = result.work_name
    event.dtstart = ::Icalendar::Values::DateTime.new(to_datetime(work.worked_at, work.start_at))
    event.dtend = ::Icalendar::Values::DateTime.new(to_datetime(work.worked_at, work.end_at))
    event.description = work.remarks
    event.uid = result.uuid.upcase
    event.created = work.created_at
    event.last_modified = work.updated_at
    return event
  end

  def make_event_for_schedule(schedule)
    schedule_model = schedule.schedule.model
    event = ::Icalendar::Event.new
    event.summary = schedule.schedule_name
    event.dtstart = ::Icalendar::Values::DateTime.new(to_datetime(schedule_model.worked_at, schedule_model.start_at))
    event.dtend = ::Icalendar::Values::DateTime.new(to_datetime(schedule_model.worked_at, schedule_model.end_at))
    event.uid = schedule.uuid.upcase
    event.created = schedule_model.created_at
    event.last_modified = schedule_model.updated_at
    return event
  end

  def create_calendar
    calendar = ::Icalendar::Calendar.new
    calendar.append_custom_property("X-WR-CALNAME;VALUE=TEXT", t("calendar.title"))
    calendar.timezone do |t|
      t.tzid = 'Asia/Tokyo'
      t.standard do |s|
        s.tzoffsetfrom = '+0900'
        s.tzoffsetto   = '+0900'
        s.tzname       = 'JST'
        s.dtstart      = '19700101T000000'
      end
    end
    return calendar
  end

  def to_datetime(date, time)
    Time.local(date.year, date.month, date.day, time.hour, time.min, 0)
  end
end
