class PersonalInformationsController < ApplicationController
  before_action :set_worker
  after_action :to_sjis, only: [:show]

  SCHEDULE_DAY = 3

  def show
    to_error_path unless @worker

    @schedules = ScheduleWorkerDecorator.decorate_collection(ScheduleWorker.for_personal(@worker, SCHEDULE_DAY))
    @results = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from))
    @lands = WorkLand.for_personal(@worker.home, now_system.start_date)
    @land_costs = LandCost.newest(Time.zone.today).where(land_id: @lands.map(&:land_id))
    @lands = WorkLandDecorator.decorate_collection(@lands).group_by(&:land)
    @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, worked_from))
    @minute = Minute.for_personal(@worker).decorate
    @company = Worker.company.first
    render layout: false
  end

  private

  def to_sjis
    headers["Content-Type"] = 'text/html; charset=Shift_JIS'
    response.body = response.body.encode(Encoding::SHIFT_JIS)
  end

  def restrict_remote_ip
  end

  def worked_from
    case Time.zone.today.month
    when 1..3
      Date.new(Time.zone.today.year - 1, 12, 1)
    when 4..7
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
