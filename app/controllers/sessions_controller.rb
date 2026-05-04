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
    user = User.find_by(login_name: params[:login_name].downcase)
    if user&.authenticate(params[:password])
      log_in(user)
      redirect_to prefixed_path(menu_index_path)
    else
      render partial: 'flash', content_type: 'text/vnd.turbo-stream.html', locals: {message: I18n.t("session.login_error") }
    end
  end

  private

  def check_login_ip_access!
    require_ip_whitelist!
  end
end
