class PersonalInformations::SchedulesController < PersonalInformationsController
  def index
    @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_personal(@worker, SCHEDULE_DAY))
    @minute = Minute.for_personal(@worker).last&.decorate
    @company = Worker.company.first
    @organization = Organization.first
  end
end
