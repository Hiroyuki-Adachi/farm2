class PersonalInformationsController < ApplicationController
  before_action :set_worker
  layout 'sm'
  include PersonalInformationsHelper

  SCHEDULE_DAY = 3

  def show
    to_error_path unless @worker

    @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_personal(@worker, SCHEDULE_DAY))
    @results = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from))
    @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, worked_from))
    @minute = Minute.for_personal(@worker).last&.decorate
    @company = Worker.company.first
  end

  protected

  def restrict_remote_ip
  end

  def set_worker
    @worker = Worker.find_by(token: params[:token] || params[:personal_information_token])
    @current_user = @worker.user
  end

  private

  def worked_from
    m = Time.zone.today.month
    if @current_user.view_month[0] <= m && m < @current_user.view_month[1]
      Date.new(Time.zone.today.year - 1, 12, 1)
    elsif @current_user.view_month[1] <= m && m < @current_user.view_month[2]
      Date.new(Time.zone.today.year, 1, 1)
    else
      Date.new(Time.zone.today.year, 7, 1)
    end
  end
end
