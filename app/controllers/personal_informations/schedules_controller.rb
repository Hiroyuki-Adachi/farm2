class PersonalInformations::SchedulesController < PersonalInformationsController
  def index
    @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_personal(@worker, SCHEDULE_DAY))
    @minute = Minute.for_personal(@worker).last&.decorate
    @tasks = TaskDecorator.decorate_collection(Task.by_worker(@worker).opened.planned_start.with_unread_count(@worker.id))
  end
end
