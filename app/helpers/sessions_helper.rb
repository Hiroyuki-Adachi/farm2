module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find(session[:user_id])
  end

  def current_organization
    @current_organization ||= Organization.find_by(id: current_user.organization_id)
  end

  def current_system
    @current_system ||= System.find_by(term: current_organization.term, organization_id: current_user.organization_id)
  end

  def current_term
    current_user.term
  end

  def now_system
    organization_id = current_user.organization_id
    @now_system ||= System.find_by(["organization_id = ? AND (current_date BETWEEN start_date AND end_date)", organization_id])
    @now_system ||= System.find_by(term: System.where(organization_id: organization_id).maximum(:term), organization_id: organization_id)
  end

  def current_name
    current_user.worker.family_name + " " + current_user.worker.first_name
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
