class PersonalInformationsController < ApplicationController
  before_action :set_worker
  after_action :to_sjis, only: [:show]

  SCHEDULE_DAY = 3

  def show
    if @worker
      @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_personal(@worker, SCHEDULE_DAY))
      @results = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from))
      @lands = WorkLandDecorator.decorate_collection(WorkLand.for_personal(@worker.home, current_system.start_date)).group_by(&:land)
      @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, worked_from))
      @company = Worker.company.first
      render layout: false
    else
      to_error_path
    end
  end

  private

  def to_sjis
    headers["Content-Type"] = 'text/html; charset=Shift_JIS'
    response.body           = response.body.encode(Encoding::SHIFT_JIS)
  end

  def restrict_remote_ip
  end

  def worked_from
    case Date.today.month
    when 1..3
      Date.new(Date.today.year - 1, 12, 1)
    when 4..7
      Date.new(Date.today.year, 1, 1)
    else
      Date.new(Date.today.year, 7, 1)
    end
  end

  def set_worker
    @worker = Worker.find_by(token: params[:token])
    @current_user = @worker.user
  end
end
