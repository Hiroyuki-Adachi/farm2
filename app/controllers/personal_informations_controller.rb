class PersonalInformationsController < ApplicationController
  before_action :set_worker
  layout 'sm'
  include PersonalInformationsHelper

  SCHEDULE_DAY = 3

  def show
    to_error_path unless @worker

    @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_personal(@worker, SCHEDULE_DAY))
    @results = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from))
    @lands = WorkLand.for_personal(@worker.home, now_system.start_date)
    @land_costs = LandCost.newest(Time.zone.today).where(land_id: @lands.map(&:land_id))
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
    @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, worked_from))
    @minute = Minute.for_personal(@worker).last&.decorate
    @company = Worker.company.first
  end

  private

  def restrict_remote_ip
  end

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

  def set_worker
    @worker = Worker.find_by(token: params[:token])
    @current_user = @worker.user
  end
end
