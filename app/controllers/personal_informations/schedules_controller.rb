class PersonalInformations::SchedulesController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_personal(@worker, SCHEDULE_DAY))
    @minute = Minute.for_personal(@worker).last&.decorate
    @company = Worker.company.first
  end
end
