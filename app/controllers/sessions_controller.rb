class SessionsController < ApplicationController
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
      render layout: false, partial: 'flash', content_type: 'text/vnd.turbo-stream.html', locals: {message: "IDまたはpasswordが間違っています。"}
    end
  end

  private

  def restrict_remote_ip
    remote_ip = IPAddr.new(request.remote_ip)
    if IpList.black_list.any? { |ip| ip.include?(remote_ip) }
      to_error_path
      return
    elsif IpList.white_list.none? { |ip| ip.include?(remote_ip) }
      redirect_to new_ip_list_path
      return
    end
  end
end
