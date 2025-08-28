require 'ipaddr'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join("frontend")
  include SessionsHelper
  helper_method :menu_name

  before_action :set_term, if: :user_present?
  before_action :restrict_remote_ip

  unless Rails.env.development? || Rails.env.test?
    rescue_from StandardError, with: :handle_error
  end

  protected

  def sum_hours_key(term)
    "sum_hours#{term}"
  end

  def count_workers_key(term)
    "count_workers#{term}"
  end

  def sum_hours(term)
    Rails.cache.fetch(sum_hours_key(term), expires_in: 1.hour) do
      WorkResult.where(work_id: Work.usual(term).select(:id)).group(:work_id).sum(:hours).to_h
    end
  end

  def count_workers(term)
    Rails.cache.fetch(count_workers_key(term), expires_in: 1.hour) do
      WorkResult.where(work_id: Work.usual(term).select(:id)).group(:work_id).count(:worker_id).to_h
    end
  end

  def permit_admin
    to_error_path unless current_user.admin?
  end

  def make_months
    results = []
    head = current_system.start_date
    while head <= Time.zone.today
      head = Date.new(head.year, head.month, 1)
      results << [head.strftime("%Y年 %m月"), head]
      head = head.next_month
    end
    return results
  end

  private

  def set_term
    @term = current_organization.term
  end

  def restrict_remote_ip
    if session[:user_id].nil? 
      redirect_to root_path
      return
    end
  end

  def permit_this_term
    to_error_path unless this_term?
  end

  def to_error_path(exception = nil)
    logger.error "[503] Service Unavailable"
    if exception
      logger.error "Exception: #{exception.class} - #{exception.message}"
      logger.error "Backtrace: #{exception.backtrace.first(5).join("\n")}"
    else
      logger.error "No exception object given (manual trigger)"
    end
    logger.error "Request: #{request.method} #{request.fullpath} from #{request.remote_ip}"
    logger.error "Params: #{request.params}"
    logger.error "User: #{current_user&.id || 'guest'}"

    render file: Rails.public_path.join('503.html'), layout: false, status: :service_unavailable
  end

  def user_present?
    session[:user_id].present?
  end

  def menu_name
    return controller_name
  end

  def respond_to_format(format, partial: nil)
    respond_to do |fmt|
      fmt.send(format) do
        partial.present? ? render(partial: partial) : render
      end
    end
  end

  def handle_error(exception = nil)
    logger.error "[500] Internal Server Error"
    logger.error({
      error: exception.class.name,
      message: exception.message,
      stack_trace: exception.backtrace.take(5),
      path: request.fullpath,
      time: Time.current,
      severity: :ERROR
    }.to_json)

    render file: Rails.public_path.join('500.html'), layout: false, status: :internal_server_error
  end
end
