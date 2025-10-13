class IpListsController < ApplicationController
  layout false
  before_action :set_ip, only: [:edit, :update]

  def new; end

  def create
    user = User.find_by(login_name: params[:login_name])
    unless user
      IpList.block_ip!(request.remote_ip)
      return to_error_path
    end

    return to_error_path unless user.linable? || user.otp_enabled

    ip = IpList.white_ip!(request.remote_ip, user)
    if user.otp_enabled || LineHookService.push_message(user.line_id, I18n.t('line_authentication', token: ip.token)).is_a?(Net::HTTPSuccess)
      redirect_to edit_ip_list_path(ip)
    else
      ip.destroy
      return to_error_path
    end
  end

  def edit; end

  def update
    if @ip.created_user.otp_enabled
      return redirect_to new_ip_list_path unless @ip.created_user.totp_verify?(params[:token])
    elsif !@ip.authenticate?(params[:token])
      return redirect_to new_ip_list_path
    end
    @ip.updated_expired_on
    log_in(@ip.created_user)
    redirect_to menu_index_path
  end

  private

  def restrict_remote_ip
    if IpList.white_list.any? { |ip| ip.include?(request.remote_ip) }
      redirect_to root_path and return
    elsif IpList.black_list.any? { |ip| ip.include?(request.remote_ip) }
      to_error_path and return
    end
  end

  def set_ip
    @ip = IpList.find_valid(params[:id], request.remote_ip)
    to_error_path and return unless @ip
  end
end
