module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def current_organization
    @current_organization ||= Organization.find_by(id: current_user.organization_id)
  end

  def current_term
    current_user.term
  end

  def current_name
    current_user.worker.family_name + " " + current_user.worker.first_name
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
