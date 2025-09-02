require 'wareki'

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    Rails.application.config.access_logger.info "PC-#{user.worker.name}"
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def current_organization
    @current_organization ||= Organization.find(current_user.organization_id)
  end

  def current_system
    @current_system ||= System.find_by!(term: current_user.term, organization_id: current_user.organization_id)
  end

  def next_system
    System.find_by(term: next_term, organization_id: current_user.organization_id)
  end

  def current_term
    current_user.term
  end

  def current_term_jp
    current_system.start_date.strftime('%Jy年')
  end 

  def next_term_jp
    next_system.start_date.strftime('%Jy年')
  end 

  def previous_term
    current_term - 1
  end

  def next_term
    current_term + 1
  end

  def last_term?
    !System.exists?(["term > ? AND organization_id = ?", current_user.term, current_user.organization_id])
  end

  def this_term?
    Time.zone.today.between?(current_system.start_date, current_system.end_date)
  end

  def now_system
    org_id = current_user.organization_id
    @now_system ||= System.find_by("organization_id = ? AND CURRENT_DATE BETWEEN start_date AND end_date", org_id) ||
                    System.find_by!(term: System.where(organization_id: org_id).maximum(:term), organization_id: org_id)
  end

  def current_name
    @current_name ||= "#{current_user.worker.family_name} #{current_user.worker.first_name}"
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
