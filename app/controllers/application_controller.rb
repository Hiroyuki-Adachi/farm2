require 'ipaddr'
class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  prepend_view_path Rails.root.join("frontend")
  include SessionsHelper
  helper_method :menu_name, :prefixed_path

  before_action :authenticate_user!
  before_action :check_access_target!, if: :user_signed_in?
  before_action :set_term, if: :user_present?

  unless Rails.env.development? || Rails.env.test?
    rescue_from StandardError, with: :handle_internal_error
  end

  protected

  def default_url_options
    prefix = normalized_path_prefix(request&.script_name) ||
             normalized_path_prefix(request&.headers&.[]("X-Forwarded-Prefix")) ||
             normalized_path_prefix(Rails.application.config.relative_url_root)

    return {} if prefix.blank?

    { script_name: prefix }
  end

  def sum_hours(term)
    work_result_totals(term)[:sum_hours]
  end

  def count_workers(term)
    work_result_totals(term)[:count_workers]
  end

  def work_result_totals(term)
    @work_result_totals ||= {}
    @work_result_totals[term] ||= begin
      totals = { sum_hours: {}, count_workers: {} }
      work_ids = Work.for_organization(current_user.organization_id).usual(term).select(:id)

      WorkResult
        .where(work_id: work_ids)
        .group(:work_id)
        .pluck(:work_id, Arel.sql("SUM(hours)"), Arel.sql("COUNT(worker_id)"))
        .each do |work_id, sum_hours, count_workers|
          totals[:sum_hours][work_id] = sum_hours
          totals[:count_workers][work_id] = count_workers
        end

      totals
    end
  end

  def authorize_admin!
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
    results
  end

  private

  def set_term
    @term = current_organization.term
  end

  def check_access_target!
    target = session[:access_target].to_s.upcase
    return true if target.blank? || target == "PC"

    expected_prefix = case target
                      when "TB" then "/tablets"
                      when "SP" then "/personal_informations"
                      else
                        nil
                      end
    return true unless expected_prefix
    return true if request_path_matches?(expected_prefix)

    log_out
    redirect_to prefixed_path(root_path)
    false
  end

  def request_path_matches?(expected_prefix)
    path = request.path.to_s
    escaped_prefix = Regexp.escape(expected_prefix)
    path.match?(%r{\A(?:/[^/]+)?#{escaped_prefix}(?:/|\z)})
  end

  def authenticate_user!
    if session[:user_id].nil?
      redirect_to prefixed_path(root_path)
      false
    end
  end

  def authorize_current_term!
    to_error_path unless this_term?
  end

  def to_error_path(exception = nil)
    render_service_unavailable(exception)
  end

  def render_service_unavailable(exception = nil)
    logger.error "[503] Service Unavailable"
    if exception
      logger.error "Exception: #{exception.class} - #{exception.message}"
      logger.error "Backtrace: #{exception.backtrace.first(5).join("\n")}"
    else
      logger.error "No exception object given (manual trigger)"
    end
    logger.error "Request: #{request.method} #{request.fullpath} from #{request.remote_ip}"
    logger.error "Params: #{request.filtered_parameters}"
    logger.error "User: #{@current_user&.id}"

    render file: Rails.public_path.join('503.html'), layout: false, status: :service_unavailable
  end

  def user_present?
    session[:user_id].present?
  end

  def user_signed_in?
    user_present?
  end

  def menu_name
    controller_name
  end

  def request_path_prefix
    normalized_path_prefix(request&.script_name) ||
      normalized_path_prefix(request&.headers&.[]("X-Forwarded-Prefix")) ||
      normalized_path_prefix(Rails.application.config.relative_url_root)
  end

  def prefixed_path(path)
    normalized = path.to_s
    prefix = request_path_prefix
    return normalized if prefix.blank? || normalized.blank? || normalized.start_with?(prefix + "/") || normalized == prefix

    normalized.start_with?("/") ? "#{prefix}#{normalized}" : "#{prefix}/#{normalized}"
  end

  def safe_return_to_path(path, fallback: nil, allowed_paths: nil, allowed_path_prefixes: nil)
    return fallback if path.blank?

    uri = URI.parse(path)
    return fallback unless uri.scheme.nil? && uri.host.nil?
    return fallback unless uri.path&.start_with?("/")

    normalized = [uri.path, uri.query].compact.join("?")
    return normalized if allowed_paths.nil? && allowed_path_prefixes.nil?
    return normalized if allowed_paths&.any? { |allowed_path| uri.path == allowed_path.to_s }
    return normalized if allowed_path_prefixes&.any? { |prefix| uri.path.start_with?(prefix.to_s) }

    fallback
  rescue URI::InvalidURIError
    fallback
  end

  def normalized_path_prefix(value)
    path = value.to_s.strip
    return nil if path.blank? || path == "/"

    normalized = path.start_with?("/") ? path : "/#{path}"
    normalized.sub(%r{/*\z}, "")
  end

  def respond_to_format(format, partial: nil)
    respond_to do |fmt|
      fmt.send(format) do
        partial.present? ? render(partial: partial) : render
      end
    end
  end

  def handle_internal_error(exception = nil)
    logger.error "[500] Internal Server Error"

    logger.error({
      error: exception&.class&.name,
      message: exception&.message,
      stack_trace: exception&.backtrace&.take(5),
      path: request.fullpath,
      time: Time.current,
      severity: :ERROR
    }.to_json)

    render file: Rails.public_path.join('500.html'), layout: false, status: :internal_server_error
  end
end
