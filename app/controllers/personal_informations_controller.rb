class PersonalInformationsController < ApplicationController
  after_action :to_sjis, only: [:show]

  def show
    @worker = Worker.where(token: params[:token]).first
    if @worker
      @results = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, WorkResult.worked_from))
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
end
