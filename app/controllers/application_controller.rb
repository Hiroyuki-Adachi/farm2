class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  PERMIT_ADDRESSES = ['127.0.0.1', '192.168.', '10.8.0.'].freeze

  before_action :set_term, if: :user_present?
  before_action :restrict_remote_ip

  protected

  def sum_hours_key(term)
    "sum_hours#{term}"
  end

  def count_workers_key(term)
    "count_workers#{term}"
  end

  def broccoli?(work)
    return current_organization.broccoli_work_type_id \
        && current_organization.broccoli_work_kind_id \
        && current_organization.broccoli_work_type_id == work.work_type_id \
        && current_organization.broccoli_work_kind_id == work.work_kind_id
  end

  private

  def set_term
    @term = current_organization.term
  end

  def restrict_remote_ip
    if PERMIT_ADDRESSES.none? { |pa| request.remote_ip.start_with?(pa)}
      to_error_path
    elsif session[:user_id].nil? && controller_name != "sessions"
      redirect_to root_path
    end
  end

  def to_error_path
    render text: 'Service Unavailable', status: 503
  end

  def user_present?
    session[:user_id].present?
  end
end
