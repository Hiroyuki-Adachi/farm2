class PersonalInformationsController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :set_worker
  layout 'sm'

  SCHEDULE_DAY = 7
  SCHEDULE_WORKERS_DAY = Schedule::DISPLAY_DAYS

  helper WorkTypesHelper

  def show
    worked_from, worked_to = between_worked_at
    @results1 = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_from, worked_to))
    @results2 = WorkResultDecorator.decorate_collection(WorkResult.for_personal(@worker, worked_to))
    @company = Worker.company.first
    Rails.application.config.access_logger.info "SP-#{@worker.name}" unless request.referer
  end

  def manifest
    personal_url = personal_information_path(token: params[:token])

    render json: {
      name: "作業日報管理",
      short_name: "作業日報",
      id: personal_url,
      start_url: personal_url,
      scope: personal_url,
      display: "standalone",
      theme_color: "#198754",
      background_color: "#ffffff",
      icons: [
        {
          src: view_context.asset_path("/images/icons/farm2-192.png"),
          sizes: "192x192",
          type: "image/png",
          purpose: "any maskable"
        },
        {
          src: view_context.asset_path("/images/icons/farm2-512.png"),
          sizes: "512x512",
          type: "image/png",
          purpose: "any maskable"
        }
      ]
    }, content_type: "application/manifest+json"
  end

  protected

  def set_worker
    @current_user = User.find_by(token: params[:token] || params[:personal_information_token])
    return to_error_path unless @current_user&.worker

    @worker = @current_user.worker
  end

  def between_worked_at
    m = Time.zone.today.month
    y = Time.zone.today.year
    case month_type(m)
    when 0
      [Date.new(y - 1, 12, 1), Date.new(y, 1, 1)]
    when 1
      [Date.new(y, 1, 1), Date.new(y, 7, 1)]
    else
      [Date.new(y, 7, 1), Date.new(y, 12, 1)]
    end
  end

  def month_type(month)
    return 0 if @current_user.view_month[0] <= month && month < @current_user.view_month[1]
    return 1 if @current_user.view_month[1] <= month && month < @current_user.view_month[2]

    2
  end
end
