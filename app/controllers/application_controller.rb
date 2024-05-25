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

  def to_error_path
    render plain: 'Service Unavailable', status: :service_unavailable
  end

  def user_present?
    session[:user_id].present?
  end

  def menu_name
    return controller_name
  end
end
