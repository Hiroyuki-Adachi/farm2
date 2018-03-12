class PersonalInformationsController < ApplicationController
  after_action :to_sjis, only: [:show]

  def show
    @worker = Worker.where(token: params[:token]).first
    if @worker
      @results = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from))
      @lands = WorkLandDecorator.decorate_collection(WorkLand.for_personal(@worker.home, worked_from)).group_by(&:land)
      @machines = MachineResultDecorator.decorate_collection(MachineResult.for_personal(@worker.home, worked_from))
      render layout: false
    else
      render nothing: true
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

end
