class PersonalInformationsController < ApplicationController
  before_action :set_worker
  layout 'sm'

  SCHEDULE_DAY = 3

  def show
    worked_from, worked_to = between_worked_at
    @results1 = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from, worked_to))
    @results2 = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_to))
    @company = Worker.company.first
    Rails.application.config.access_logger.info "SP-#{@worker.name}" unless request.referer
  end

  protected

  def restrict_remote_ip; end

  def set_worker
    @worker = Worker.find_by(token: params[:token] || params[:personal_information_token])
    to_error_path unless @worker
    @current_user = @worker&.user
  end

  def between_worked_at
    m = Time.zone.today.month
    y = Time.zone.today.year
    case month_type(m)
    when 0
      return Date.new(y - 1, 12, 1), Date.new(y, 1, 1)
    when 1
      return Date.new(y, 1, 1), Date.new(y, 7, 1)
    else
      return Date.new(y, 7, 1), Date.new(y, 12, 1)
    end
  end

  def month_type(month)
    return 0 if @current_user.view_month[0] <= month && month < @current_user.view_month[1]
    return 1 if @current_user.view_month[1] <= month && month < @current_user.view_month[2]
    return 2
  end
end
