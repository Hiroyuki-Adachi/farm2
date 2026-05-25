class SessionsController < ApplicationController
  include IpRestrictedLogin
  layout false
  skip_before_action :authenticate_user!
  before_action :check_login_ip_access!

  def index
    log_out
    redirect_to prefixed_path(root_path)
  end

  def new
    log_out
  end

  def create
    user = User.find_by(login_name: params[:login_name].to_s.downcase)
    user&.unlock_if_expired!

    if user&.login_locked?
      Rails.logger.warn("Locked login attempt for user_id=#{user.id}")
      render_login_error
    elsif user&.authenticate(params[:password])
      user.reset_login_failures!
      log_in(user)
      redirect_to prefixed_path(menu_index_path)
    else
      user&.register_failed_login!
      Rails.logger.warn("User locked after failed login attempts for user_id=#{user.id}") if user&.login_locked?
      render_login_error
    end
  end

  private

  def check_login_ip_access!
    require_ip_whitelist!
  end

  def render_login_error
    render partial: 'flash', content_type: 'text/vnd.turbo-stream.html', locals: { message: I18n.t("session.login_error") }
  end
end
