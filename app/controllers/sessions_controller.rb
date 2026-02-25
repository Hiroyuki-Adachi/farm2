class SessionsController < ApplicationController
  layout false

  def index
    log_out
    redirect_to root_path
  end

  def new
    log_out
  end

  def create
    user = User.find_by(login_name: params[:login_name].downcase)
    if user&.authenticate(params[:password])
      log_in(user)
      redirect_to menu_index_path
    else
      render partial: 'flash', content_type: 'text/vnd.turbo-stream.html', locals: {message: I18n.t("session.login_error") }
    end
  end

  private

  def restrict_remote_ip
    if IpList.black_list.any? { |ip| ip.include?(request.remote_ip) }
      to_error_path
      return
    elsif IpList.white_list.none? { |ip| ip.include?(request.remote_ip) }
      redirect_to new_ip_list_path
      return
    end
  end
end
